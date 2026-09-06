import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const fmt = (n: number) => {
  if (n < 1_000) return `${n}`;
  if (n < 1_000_000) return `${(n / 1_000).toFixed(1)}k`;
  return `${(n / 1_000_000).toFixed(1)}M`;
};

function transformStatus(
  key: string,
  value: string,
): string | undefined {
  switch (key) {
    case "caveman": {
      const level = value.match(
        /(LITE|FULL|ULTRA|MICRO|文言文極|文言文|文言)/
      )?.[1];

      if (!level) return undefined;

      const short: Record<string, string> = {
        LITE: "lite",
        FULL: "full",
        ULTRA: "ultra",
        MICRO: "micro",
        文言: "文",
        文言文: "文",
        文言文極: "文極",
      };

      return `caveman:${short[level] ?? level}`;
    }

    case "ponytail": {
      const level = value.match(/(LITE|FULL|ULTRA)/i)?.[1];
      return level ? `ponytail:${level.toLowerCase()}` : undefined;
    }

    case "plan-mode": {
      const progress = value.match(/(\d+\/\d+)/)?.[1];

      if (progress) return `plan:${progress}`;
      if (/plan/i.test(value)) return "plan";

      return undefined;
    }

    // Example:
    // case "some-annoying-plugin":
    //   return undefined;

    default:
      return value;
  }
}

export default function statusline(pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsubscribe =
        footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsubscribe,

        invalidate() {},

        render(width: number): string[] {
          //
          // Line 1: cwd + git branch
          //
          const branch = footerData.getGitBranch();

          let cwd = ctx.cwd.replace(
            process.env.HOME ?? "",
            "~",
          );

          if (branch) cwd += ` (${branch})`;

          const cwdLine = truncateToWidth(
            theme.fg("dim", cwd),
            width,
          );

          //
          // Usage
          //
          let input = 0;
          let output = 0;
          let cost = 0;

          for (const entry of ctx.sessionManager.getEntries()) {
            if (
              entry.type === "message" &&
              entry.message.role === "assistant"
            ) {
              const msg = entry.message as AssistantMessage;

              input += msg.usage.input;
              output += msg.usage.output;
              cost += msg.usage.cost.total;
            }
          }

          //
          // Context
          //
          const context = ctx.getContextUsage();

          const contextText = context
            ? context.percent === null
              ? `?/${fmt(context.contextWindow)}`
              : `${context.percent.toFixed(0)}%/${fmt(
                  context.contextWindow
                )}`
            : "?";

          const stats =
            `↑${fmt(input)} ↓${fmt(output)} ` +
            `$${cost.toFixed(3)} ${contextText}`;

          //
          // Model
          //
          let model = ctx.model?.id ?? "no-model";

          if (ctx.model?.reasoning && ctx.thinkingLevel) {
            model += ` • ${ctx.thinkingLevel}`;
          }

          const joinLeftRight = (
            left: string,
            right: string,
          ) => {
            const padding = " ".repeat(
              Math.max(
                2,
                width -
                  visibleWidth(left) -
                  visibleWidth(right),
              ),
            );
            return truncateToWidth(
              left + padding + right,
              width,
            );
          };

          //
          // Extension statuses
          //
          const statuses = [...footerData.getExtensionStatuses()]
            .sort(([a], [b]) => a.localeCompare(b))
            .map(([key, value]) => transformStatus(key, value))
            .filter((x): x is string => Boolean(x));

          const statusText = statuses.join("  ");

          return [
            joinLeftRight(cwdLine, theme.fg("dim", model)),
            joinLeftRight(
              theme.fg("dim", statusText),
              theme.fg("dim", stats),
            ),
          ];
        },
      };
    });
  });
}
