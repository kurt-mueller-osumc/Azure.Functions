namespace Azure.Starter.Functions

open Microsoft.Azure.Functions.Worker
open Microsoft.Extensions.Logging

type public ProcessBlob(loggerFactory: ILoggerFactory) =
    let logger = loggerFactory.CreateLogger<ProcessBlob>()

    [<Function("ProcessBlob")>]
    member public _.Run([<BlobTrigger("samples-workitems/{name}", Connection = "")>] myBlob: string, name: string) =
        logger.LogInformation($"F# Blob trigger function Processed blob\n Name: {name} \n Data: {myBlob}")
