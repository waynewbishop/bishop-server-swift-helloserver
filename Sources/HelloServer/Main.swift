// Copyright 2025 Wayne W Bishop. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import Vapor
import OpenAPIRuntime
import OpenAPIVapor
import Logging
import ServiceLifecycle

@main
struct HelloServerApp {
    static func main() async throws {
        let (_, serviceGroup) = try await configServer()
        try await serviceGroup.run()
    }
}

// Simple service implementation
struct ServerService: Service {
    var app: Application
    func run() async throws {
        try await app.execute()
    }
}

//MARK: Helper functions

/// Global signal handler function that doesn't capture any context
func sigtstpHandler(signal: Int32) {
    // Can't use logger here, but can print to console
    print("[HelloServer] Received Ctrl+Z, converting to graceful shutdown")
    kill(getpid(), SIGINT)
}

/// Server configuation
func configServer() async throws -> (Application, ServiceGroup) {
    
    let logger = Logger(label: "com.example.hello-server")
    logger.info("Starting Hello Server application")
    
    signal(SIGTSTP, sigtstpHandler)
    logger.notice("Server started. Use Control+C to shut down gracefully.")
    
    let app = try await Vapor.Application.make()
    
    
    //LoggingMiddleware is applied first, so it will log requests even if they later
    //fail with errors, giving you a complete picture of your application's request handling
    
    app.middleware.use(LoggingMiddleware(logger: logger))
    app.middleware.use(ErrorHandlingMiddleware())
    
    let transport = VaporTransport(routesBuilder: app)
    let handler = HelloHandler()
    try handler.registerHandlers(on: transport, serverURL: URL(string: "/")!)
    logger.info("API handlers registered successfully")
    
    let serverService = ServerService(app: app)
    let serviceGroup = ServiceGroup(
        services: [serverService],
        gracefulShutdownSignals: [.sigint, .sigquit],
        cancellationSignals: [.sigterm],
        logger: logger
    )
    
    logger.notice("Starting service group")
    return (app, serviceGroup)
}
