#!/usr/bin/env node
/**
 * Unit tests for spicy-male-erotic-prompt-optimizer Error Handling protocol.
 * Pure logic tests — no image generation. Validates classification + recovery
 * decision rules so the protocol stays enforceable and regression-safe.
 *
 * Run:
 *   node skill-orchestrator/scripts/spicy-error-unit-tests.mjs
 */

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SPICY_SKILL = path.resolve(
  __dirname,
  "../../spicy-male-erotic-prompt-optimizer/SKILL.md",
);

const FAILURE_CLASSES = [
  "moderation_block",
  "partial_degraded",
  "phenotype_lock_miss",
  "interface_mismatch",
  "progressive_intensification_failure",
  "tool_pipeline_error",
];

/**
 * Classify a simulated spicy outcome into a failure class.
 * Mirrors the skill's Failure Classes section.
 */
function classifySpicyFailure(outcome) {
  if (!outcome || outcome.type === "success") return null;
  if (outcome.blocked === true || outcome.empty === true || outcome.status === "refused") {
    return "moderation_block";
  }
  if (outcome.error || outcome.timeout || outcome.toolThrow) {
    return "tool_pipeline_error";
  }
  if (outcome.interface === "ios" && outcome.softBlock) {
    return "interface_mismatch";
  }
  if (outcome.interface === "web" && outcome.iosWouldBlock) {
    return "interface_mismatch";
  }
  if (outcome.generated && outcome.identityDrift) {
    return "phenotype_lock_miss";
  }
  if (outcome.generated && (outcome.plasticSkin || outcome.missingTexture || outcome.wrongPose)) {
    return "partial_degraded";
  }
  if (outcome.editStep && outcome.editTriggeredBlock) {
    return "progressive_intensification_failure";
  }
  if (outcome.generated && outcome.phenotypeMismatch) {
    return "phenotype_lock_miss";
  }
  return "moderation_block"; // safe default for unknown failures
}

/**
 * Ordered recovery steps for a failure class (skill protocol).
 */
function recoveryStepsFor(failureClass, context = {}) {
  const steps = [];
  // Always start with re-frame + milder base for content failures
  if (
    failureClass === "moderation_block" ||
    failureClass === "progressive_intensification_failure"
  ) {
    steps.push("reframe_artistic");
    steps.push("milder_base_first");
  }
  if (failureClass === "phenotype_lock_miss" || failureClass === "partial_degraded") {
    steps.push("restore_lock_block");
    if (context.faceDrift) steps.push("require_reference_image");
  }
  if (failureClass === "interface_mismatch") {
    if (context.interface === "ios" || context.softBlock) {
      steps.push("ios_shorten_prompt");
      steps.push("progressive_edit_path");
    } else {
      steps.push("document_ios_delta");
      steps.push("keep_web_path");
    }
  }
  if (failureClass === "tool_pipeline_error") {
    steps.push("retry_tool_once");
    steps.push("log_and_continue");
  }
  // After 2 re-frames still blocked → local fallback
  if (
    (failureClass === "moderation_block" ||
      failureClass === "progressive_intensification_failure") &&
    (context.reframeAttempts ?? 0) >= 2
  ) {
    steps.push("fallback_local_nsfw_comfyui");
  }
  steps.push("log_and_continue");
  // de-dupe while preserving order
  return [...new Set(steps)];
}

function hardStopViolated(action) {
  const stops = {
    loop_same_prompt_3x: true,
    remove_artistic_framing: true,
    underage_content: true,
    claim_spicy_on_after_block: true,
  };
  return !!stops[action];
}

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

function runTests() {
  const results = [];
  function test(name, fn) {
    try {
      fn();
      results.push({ name, ok: true });
      console.log(`  PASS  ${name}`);
    } catch (e) {
      results.push({ name, ok: false, error: e.message });
      console.log(`  FAIL  ${name}: ${e.message}`);
    }
  }

  console.log("=== Spicy Error Handling Unit Tests ===\n");

  // --- Skill file presence ---
  test("spicy SKILL.md exists with Error Handling section", () => {
    assert(fs.existsSync(SPICY_SKILL), "SKILL.md missing");
    const body = fs.readFileSync(SPICY_SKILL, "utf8");
    assert(body.includes("## Error Handling (Spicy Mode — Required)"), "missing Error Handling H2");
    assert(body.includes("### Failure Classes"), "missing Failure Classes");
    assert(body.includes("### Recovery Protocol"), "missing Recovery Protocol");
    assert(body.includes("### Hard Stops"), "missing Hard Stops");
    for (const phrase of [
      "Moderation block",
      "Partial / degraded",
      "Phenotype lock miss",
      "Interface mismatch",
      "Progressive intensification",
      "Tool / pipeline error",
    ]) {
      assert(body.includes(phrase), `missing class phrase: ${phrase}`);
    }
  });

  // --- Classification ---
  test("classify moderation block (empty)", () => {
    assert(classifySpicyFailure({ empty: true }) === "moderation_block", "empty");
    assert(classifySpicyFailure({ blocked: true }) === "moderation_block", "blocked");
    assert(classifySpicyFailure({ status: "refused" }) === "moderation_block", "refused");
  });

  test("classify phenotype lock miss", () => {
    assert(
      classifySpicyFailure({ generated: true, identityDrift: true }) === "phenotype_lock_miss",
    );
    assert(
      classifySpicyFailure({ generated: true, phenotypeMismatch: true }) ===
        "phenotype_lock_miss",
    );
  });

  test("classify partial/degraded", () => {
    assert(
      classifySpicyFailure({ generated: true, plasticSkin: true }) === "partial_degraded",
    );
    assert(
      classifySpicyFailure({ generated: true, missingTexture: true }) === "partial_degraded",
    );
  });

  test("classify interface mismatch (iOS soft-block)", () => {
    assert(
      classifySpicyFailure({ interface: "ios", softBlock: true }) === "interface_mismatch",
    );
  });

  test("classify progressive intensification failure", () => {
    assert(
      classifySpicyFailure({ editStep: true, editTriggeredBlock: true }) ===
        "progressive_intensification_failure",
    );
  });

  test("classify tool/pipeline error", () => {
    assert(classifySpicyFailure({ error: "timeout" }) === "tool_pipeline_error");
    assert(classifySpicyFailure({ toolThrow: true }) === "tool_pipeline_error");
  });

  test("success returns null failure class", () => {
    assert(classifySpicyFailure({ type: "success" }) === null);
    assert(classifySpicyFailure(null) === null);
  });

  // --- Recovery ordering ---
  test("moderation recovery starts with reframe + milder base", () => {
    const steps = recoveryStepsFor("moderation_block", { reframeAttempts: 0 });
    assert(steps[0] === "reframe_artistic", `got ${steps[0]}`);
    assert(steps.includes("milder_base_first"), "missing milder_base_first");
    assert(!steps.includes("fallback_local_nsfw_comfyui"), "too early for local fallback");
  });

  test("moderation after 2 reframes triggers local fallback", () => {
    const steps = recoveryStepsFor("moderation_block", { reframeAttempts: 2 });
    assert(steps.includes("fallback_local_nsfw_comfyui"), "expected local fallback");
  });

  test("phenotype miss restores lock block", () => {
    const steps = recoveryStepsFor("phenotype_lock_miss", { faceDrift: true });
    assert(steps.includes("restore_lock_block"));
    assert(steps.includes("require_reference_image"));
  });

  test("iOS soft-block uses shorten + progressive edit", () => {
    const steps = recoveryStepsFor("interface_mismatch", {
      interface: "ios",
      softBlock: true,
    });
    assert(steps.includes("ios_shorten_prompt"));
    assert(steps.includes("progressive_edit_path"));
  });

  test("every recovery path logs", () => {
    for (const fc of FAILURE_CLASSES) {
      const steps = recoveryStepsFor(fc, {});
      assert(steps.includes("log_and_continue"), `${fc} missing log`);
    }
  });

  // --- Hard stops ---
  test("hard stops catch forbidden actions", () => {
    assert(hardStopViolated("loop_same_prompt_3x"));
    assert(hardStopViolated("remove_artistic_framing"));
    assert(hardStopViolated("underage_content"));
    assert(hardStopViolated("claim_spicy_on_after_block"));
    assert(!hardStopViolated("reframe_artistic"));
  });

  // --- Failure class enum completeness ---
  test("all six failure classes are known", () => {
    assert(FAILURE_CLASSES.length === 6);
  });

  const passed = results.filter((r) => r.ok).length;
  const failed = results.length - passed;
  console.log(`\n=== ${passed}/${results.length} passed, ${failed} failed ===`);
  process.exit(failed ? 1 : 0);
}

runTests();
