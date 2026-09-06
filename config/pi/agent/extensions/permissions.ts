/**
 * Permission extension for pi.
 *
 * An approval gate (NOT a sandbox): intercepts `tool_call`, never overrides
 * or re-registers tools, so it composes with extensions that replace tool
 * implementations (e.g. Gondolin).
 *
 * Modes:
 *   ask  - read/grep/find/ls run freely; everything else requires confirmation
 *   auto - everything allowed, no confirmation
 *   plan - read-only tools + present_plan run freely; edit/write blocked;
 *          bash and custom tools prompt per call
 *
 * Usage: pi -e ./permissions.ts   (or copy into ~/.pi/agent/extensions/)
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { getMarkdownTheme } from "@earendil-works/pi-coding-agent";
import { Key, Markdown } from "@earendil-works/pi-tui";
import { Type } from "typebox";

type Mode = "ask" | "auto" | "plan";
const MODES: Mode[] = ["ask", "auto", "plan"];
const READ_ONLY = new Set(["read", "grep", "find", "ls"]);
// Custom/built-in tools that never touch your system; safe to run unattended.
const ALWAYS_SAFE = new Set(["todo", "ask_user_question"]);
const WRITE_TOOLS = new Set(["edit", "write"]);

// ponytail: first-word allowlist, not shell parsing — anything ambiguous prompts.
const READONLY_BASH = new Set([
	"ls", "cat", "head", "tail", "grep", "rg", "find", "fd", "tree", "wc",
	"file", "stat", "du", "df", "which", "pwd", "echo", "date", "whoami",
	"realpath", "basename", "dirname", "diff", "sort", "uniq", "jq",
]);
const READONLY_GIT = new Set(["status", "log", "diff", "show", "branch", "blame", "rev-parse", "remote", "tag"]);

/** True if a bash command can only read. Conservative: any separator,
 *  redirection, or command substitution disqualifies. */
function isReadonlyBash(command: string): boolean {
	if (/[;&`<>]|\$\(/.test(command)) return false; // separators, redirects, subst
	const segments = command.split("|").map((s) => s.trim()).filter(Boolean);
	return segments.every((seg) => {
		const [name, arg1] = seg.split(/\s+/);
		if (name === "git") return arg1 !== undefined && READONLY_GIT.has(arg1);
		return READONLY_BASH.has(name);
	});
}

/** Count lines in a (possibly non-string) value. */
function countLines(s: unknown): number {
	return typeof s === "string" && s.length > 0 ? s.split("\n").length : 0;
}

/** Changed-line counts for one old/new text block: trims common
 *  prefix/suffix lines, counts what remains. */
function diffCounts(oldText: unknown, newText: unknown): { add: number; del: number } {
	if (typeof oldText !== "string" || typeof newText !== "string") {
		return { add: countLines(newText), del: countLines(oldText) };
	}
	const a = oldText.split("\n");
	const b = newText.split("\n");
	let start = 0;
	while (start < a.length && start < b.length && a[start] === b[start]) start++;
	let endA = a.length;
	let endB = b.length;
	while (endA > start && endB > start && a[endA - 1] === b[endB - 1]) {
		endA--;
		endB--;
	}
	return { add: endB - start, del: endA - start };
}

/** One-line summary of what is about to execute. Full diff shown by pi's UI. */
function describe(toolName: string, input: Record<string, unknown>): string {
	if (toolName === "bash") return String(input.command ?? JSON.stringify(input));
	if (toolName === "edit") {
		const edits = Array.isArray(input.edits) ? (input.edits as Array<{ oldText?: unknown; newText?: unknown }>) : [];
		let add = 0;
		let del = 0;
		for (const e of edits) {
			const d = diffCounts(e.oldText, e.newText);
			add += d.add;
			del += d.del;
		}
		return `${input.path} (+${add} −${del}, ${edits.length} edit${edits.length === 1 ? "" : "s"})`;
	}
	if (toolName === "write") {
		return `${input.path} (+${countLines(input.content)} lines)`;
	}
	if (typeof input.path === "string") return input.path;
	const s = JSON.stringify(input) ?? "";
	return s.length > 200 ? `${s.slice(0, 200)}…` : s;
}

export default function (pi: ExtensionAPI) {
	let mode: Mode = "auto";

	const MODE_COLOR: Record<Mode, "warning" | "success" | "accent"> = {
		ask: "warning",  // yellow: prompts coming
		auto: "success", // green: full speed
		plan: "accent",  // blue: read-only
	};

	function applyMode(next: Mode, ctx: ExtensionContext) {
		mode = next;
		ctx.ui.setStatus("perm", ctx.ui.theme.fg(MODE_COLOR[mode], `perm:${mode}`));
	}

	pi.on("session_start", async (_event, ctx) => {
		applyMode("auto", ctx); // default on every fresh session
	});

	pi.on("tool_call", async (event, ctx) => {
		const tool = event.toolName;

		if (READ_ONLY.has(tool) || ALWAYS_SAFE.has(tool) || tool === "present_plan") return undefined;

		if (tool === "bash" && mode === "plan" && isReadonlyBash(String((event.input as { command?: unknown }).command ?? ""))) {
			return undefined;
		}

		if (mode === "plan" && WRITE_TOOLS.has(tool)) {
			return { block: true, reason: `Blocked by permissions: plan mode blocks ${tool}. Present your plan via the present_plan tool when ready.` };
		}

		if (mode === "auto") return undefined;

		// ask mode, and plan mode for bash/custom tools: prompt per call.
		if (!ctx.hasUI) {
			return { block: true, reason: `Blocked by permissions: ${tool} requires confirmation but no UI is available.` };
		}
		const summary = describe(tool, event.input as Record<string, unknown>);
		const choice = await ctx.ui.select(`${tool}: ${summary}`, ["Allow", "Reject"]);
		if (choice !== "Allow") {
			const notes = await ctx.ui.input("Rejected — notes for the agent (optional):");
			return { block: true, reason: `User rejected ${tool} call in permission prompt.${notes ? ` User notes: ${notes}` : ""}` };
		}
		return undefined;
	});

	// Tell the agent it is in plan mode and how to exit it.
	pi.on("before_agent_start", async (event) => {
		if (mode !== "plan") return undefined;
		return {
			systemPrompt: `${event.systemPrompt}\n\nPLAN MODE is active: read-only tools (read, grep, find, ls) run freely, as do read-only shell commands (ls, cat, grep, git status/log/diff, etc.). Prefer the dedicated read/grep/find/ls tools over bash. File edits/writes are blocked; other bash commands prompt the user per call. Research the codebase, then present your complete implementation plan via the present_plan tool for user approval.`,
		};
	});

	// Render submitted plans into the transcript (immediate, display-only).
	pi.registerEntryRenderer("perm-plan", (entry) => {
		const data = entry.data as { plan?: string };
		return new Markdown(`## Implementation Plan\n\n${data.plan ?? ""}`, 1, 1, getMarkdownTheme());
	});

	let lastPlan: string | null = null;

	// Plan approval: agent presents plan, user approves -> switch to ask mode.
	pi.registerTool({
		name: "present_plan",
		label: "Present Plan",
		description: "Present your implementation plan for user approval. Only meaningful in plan mode.",
		parameters: Type.Object({
			plan: Type.String({ description: "The complete implementation plan" }),
		}),
		async execute(_id, params, _signal, _onUpdate, ctx) {
			if (mode !== "plan") {
				return { content: [{ type: "text", text: "Not in plan mode; no approval needed. Proceed." }], details: {} };
			}
			if (!ctx.hasUI) {
				throw new Error("Cannot present plan: no UI available for approval.");
			}
			// Display-only entry: renders in transcript immediately (sendMessage would queue until turn end).
			pi.appendEntry("perm-plan", { plan: params.plan });
			lastPlan = params.plan;
			const choice = await ctx.ui.select("Approve this plan?", ["Approve", "Approve & compact", "Reject"]);
			if (choice !== "Approve" && choice !== "Approve & compact") {
				const feedback = await ctx.ui.input("Rejected — notes for the agent (optional):");
				return { content: [{ type: "text", text: `Plan rejected by user.${feedback ? ` User notes: ${feedback}` : ""} You are still in plan mode (read-only); refine the plan accordingly and present it again via the present_plan tool.` }], details: {} };
			}
			applyMode("ask", ctx);
			ctx.ui.notify("Plan approved → perm: ask", "info");
			if (choice === "Approve & compact") {
				// Compact first to free context; keep the plan intact by passing it in
				// both the compaction instructions and the kickoff message below.
				ctx.compact({
					customInstructions: `Compact this session. The following approved implementation plan MUST be preserved verbatim in your summary:\n\n${params.plan}`,
					onComplete: () => {
						pi.sendUserMessage(`The context was compacted. Implement this approved plan now:\n\n${params.plan}`);
					},
					onError: (error) => {
						ctx.ui.notify(`Compaction failed (${error.message}) — implementing plan without compaction.`, "warning");
						pi.sendUserMessage(`Implement this approved plan now:\n\n${params.plan}`);
					},
				});
				return { content: [{ type: "text", text: "Plan approved. Permission mode switched to 'ask'. Context will be compacted (plan preserved), then you must implement the plan from the next user message." }], details: {} };
			}
			return { content: [{ type: "text", text: "Plan approved. Permission mode switched to 'ask': edit/write/bash calls will now prompt the user per call. Implement the plan." }], details: {} };
		},
	});

	pi.registerCommand("show-plan", {
		description: "Re-display the most recently submitted plan",
		handler: async (_args, ctx) => {
			if (lastPlan === null) {
				ctx.ui.notify("No plan has been submitted this session.", "warning");
				return;
			}
			pi.appendEntry("perm-plan", { plan: lastPlan });
		},
	});

	pi.registerCommand("perm", {
		description: "Show or set permission mode (ask | auto | plan)",
		getArgumentCompletions: (prefix: string) => {
			const items = MODES.map((m) => ({ value: m, label: m }));
			const filtered = items.filter((i) => i.value.startsWith(prefix));
			return filtered.length > 0 ? filtered : null;
		},
		handler: async (args, ctx) => {
			const arg = args.trim().toLowerCase() as Mode;
			if (!arg) {
				ctx.ui.notify(`Permission mode: ${mode} (/perm ask|auto|plan)`, "info");
				return;
			}
			if (!MODES.includes(arg)) {
				ctx.ui.notify(`Unknown mode "${arg}". Use ask, auto, or plan.`, "error");
				return;
			}
			applyMode(arg, ctx);
			ctx.ui.notify(`Permission mode: ${mode}`, "info");
		},
	});

	pi.registerShortcut(Key.ctrlShift("m"), {
		description: "Cycle permission mode (ask -> auto -> plan)",
		handler: async (ctx) => {
			const next = MODES[(MODES.indexOf(mode) + 1) % MODES.length];
			applyMode(next, ctx);
			ctx.ui.notify(`Permission mode: ${next}`, "info");
		},
	});
}
