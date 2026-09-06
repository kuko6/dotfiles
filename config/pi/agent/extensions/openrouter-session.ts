import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("before_provider_headers", (event, ctx) => {
    if (ctx.model?.provider !== "openrouter") {
      return;
    }

    const sessionId = ctx.sessionManager.getSessionId();

    if (sessionId) {
      event.headers["x-session-id"] = sessionId;
    }
  });

  pi.registerCommand("openrouter-session", {
    description: "Show the OpenRouter session ID",
    handler: async (_args, ctx) => {
      ctx.ui.notify(
        `OpenRouter session: ${ctx.sessionManager.getSessionId()}`,
        "info",
      );
    },
  });
}
