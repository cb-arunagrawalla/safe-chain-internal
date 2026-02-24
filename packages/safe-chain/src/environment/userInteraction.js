// oxlint-disable no-console
import chalk from "chalk";
import readline from "readline";
import { isCi } from "./environment.js";
import {
  getLoggingLevel,
  LOGGING_SILENT,
  LOGGING_VERBOSE,
} from "../config/settings.js";

/**
 * @type {{ bufferOutput: boolean, bufferedMessages:(() => void)[]}}
 */
const state = {
  bufferOutput: false,
  bufferedMessages: [],
};

function isSilentMode() {
  return getLoggingLevel() === LOGGING_SILENT;
}

function isVerboseMode() {
  return getLoggingLevel() === LOGGING_VERBOSE;
}

function emptyLine() {
  if (isSilentMode()) return;

  writeInformation("");
}

/**
 * @param {string} message
 * @param {...any} optionalParams
 * @returns {void}
 */
function writeInformation(message, ...optionalParams) {
  if (isSilentMode()) return;

  writeOrBuffer(() => console.log(message, ...optionalParams));
}

/**
 * @param {string} message
 * @param {...any} optionalParams
 * @returns {void}
 */
function writeWarning(message, ...optionalParams) {
  if (isSilentMode()) return;

  if (!isCi()) {
    message = chalk.yellow(message);
  }
  writeOrBuffer(() => console.warn(message, ...optionalParams));
}

/**
 * @param {string} message
 * @param {...any} optionalParams
 * @returns {void}
 */
function writeError(message, ...optionalParams) {
  if (!isCi()) {
    message = chalk.red(message);
  }
  writeOrBuffer(() => console.error(message, ...optionalParams));
}

function writeExitWithoutInstallingMaliciousPackages() {
  let message = "Safe-chain: Exiting without installing malicious packages.";
  if (!isCi()) {
    message = chalk.red(message);
  }
  writeOrBuffer(() => console.error(message));
}

/**
 * @param {string} message
 * @param {...any} optionalParams
 * @returns {void}
 */
function writeVerbose(message, ...optionalParams) {
  if (!isVerboseMode()) return;

  writeOrBuffer(() => console.log(message, ...optionalParams));
}

/**
 *
 * @param {() => void} messageFunction
 */
function writeOrBuffer(messageFunction) {
  if (state.bufferOutput) {
    state.bufferedMessages.push(messageFunction);
  } else {
    messageFunction();
  }
}

function startBufferingLogs() {
  state.bufferOutput = true;
  state.bufferedMessages = [];
}

function writeBufferedLogsAndStopBuffering() {
  state.bufferOutput = false;
  for (const log of state.bufferedMessages) {
    log();
  }
  state.bufferedMessages = [];
}

/**
 * Prompts user for confirmation to skip minimum package age protection
 * Shows a strongly-worded RED warning before asking for y/n input
 * @returns {Promise<boolean>} true if user confirms, false otherwise
 */
async function promptSkipMinimumAgeConfirmation() {
  return new Promise((resolve) => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    const warningMessage = isCi()
      ? `⚠️  WARNING: You are about to bypass the minimum package age protection!

This security feature prevents installation of packages published within the last 15 days,
protecting you from potential supply chain attacks and malicious packages.

Bypassing this protection significantly increases your risk exposure.

Are you sure you want to proceed? (y/N): `
      : `${chalk.red.bold("⚠️  WARNING:")} ${chalk.red(
          "You are about to bypass the minimum package age protection!"
        )}

${chalk.yellow(
  "This security feature prevents installation of packages published within the last 15 days,"
)}
${chalk.yellow(
  "protecting you from potential supply chain attacks and malicious packages."
)}

${chalk.red.bold("Bypassing this protection significantly increases your risk exposure.")}

Are you sure you want to proceed? (y/N): `;

    rl.question(warningMessage, (answer) => {
      rl.close();

      const normalizedAnswer = answer.trim().toLowerCase();
      if (normalizedAnswer === "y" || normalizedAnswer === "yes") {
        resolve(true);
      } else {
        resolve(false);
      }
    });

    rl.on("close", () => {
      if (!rl.terminal) {
        resolve(false);
      }
    });
  });
}

export const ui = {
  writeVerbose,
  writeInformation,
  writeWarning,
  writeError,
  writeExitWithoutInstallingMaliciousPackages,
  emptyLine,
  startBufferingLogs,
  writeBufferedLogsAndStopBuffering,
  promptSkipMinimumAgeConfirmation,
};
