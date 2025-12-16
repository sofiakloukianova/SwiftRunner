//
//  ScriptExecutor.swift
//  GUItool
//
//  Created by Sofia KL on 14.12.25.
//

import Foundation
import Observation

@Observable
final class ScriptExecutor {

    var output: String = ""
    var isRunning: Bool = false
    var lastExitCode: Int? = nil

    private var process: Process?
    private let queue = DispatchQueue(label: "ScriptExecutor.queue")
    private var executionTempURL: URL?

    // MARK: - Public API

    // Starts execution of the given script in seperate thread if no script is currently running
    func run(script: String, filename: String) {
        guard !isRunning else { return }

        output = ""
        lastExitCode = nil
        isRunning = true

        queue.async {
            self.execute(script: script, filename: filename)
        }
    }

    func stop() {
        process?.terminate()
    }

    // MARK: - Execution

    private func execute(script: String, filename: String) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        self.executionTempURL = tempURL
        
        // Write editor contents to a disposable execution file
        // User source files are treated as read-only inputs (!)
        do {
            try script.write(to: tempURL, atomically: true, encoding: .utf8)
        } catch {
            appendOutput("Failed to write script: \(error)\n")
            finish(exitCode: -1)
            return
        }

        let process = Process()
        self.process = process

        // Run "/usr/bin/env swift /path/to/temp/<filename>.swift"
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", tempURL.path]

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        
        // Capture both stdout and stderr for live output
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        attachPipe(stdoutPipe)
        attachPipe(stderrPipe)

        process.terminationHandler = { process in
            stdoutPipe.fileHandleForReading.readabilityHandler = nil
            stderrPipe.fileHandleForReading.readabilityHandler = nil
            self.finish(exitCode: Int(process.terminationStatus))
        }

        do {
            try process.run()
        } catch {
            appendOutput("Failed to start process: \(error)\n")
            finish(exitCode: -1)
        }
    }

    // MARK: - Helpers
    
    private func attachPipe(_ pipe: Pipe) {
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty else { return }
            self?.appendOutput(String(decoding: data, as: UTF8.self))
        }
    }

    private func appendOutput(_ text: String) {
        DispatchQueue.main.async {
            if let tempURL = self.executionTempURL {
                self.output.append(self.cleanOutput(text, tempURL: tempURL))
            } else {
                self.output.append(text)
            }
        }
    }

    private func finish(exitCode: Int) {
        DispatchQueue.main.async {
            self.lastExitCode = exitCode
            self.isRunning = false
            self.process = nil
            self.executionTempURL = nil
        }
    }
    
    // Remove temporary execution URL from UI output
    // Keeps compiler diagnostics readable
    private func cleanOutput(_ text: String, tempURL: URL) -> String {
        text.replacingOccurrences(of: tempURL.path, with: tempURL.lastPathComponent)
    }
}

