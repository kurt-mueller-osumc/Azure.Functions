module Azure.Starter.Functions.Program

open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Hosting

open Serilog

/// Add our own logger so we can write both to the console and append to a file.
/// You'll be able to find the the log in the /bin/output folder from the project root.
let configureServices (ctx: HostBuilderContext) (services: IServiceCollection) : unit =
    let logFilename = "azure.starter.functions.log"

    let logger = LoggerConfiguration().WriteTo.Console()
                                      .WriteTo.File(logFilename)
                                      .CreateLogger()

    services.AddLogging(fun loggingBuilder ->
        loggingBuilder.AddSerilog(logger) |> ignore
    ) |> ignore

[<EntryPoint>]
(HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices (configureServices))
    .Build()
    .Run()
