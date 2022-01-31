#r "nuget: Azure.Storage.Blobs, 12.11.0-beta.2"

open Azure.Core
open Azure.Storage.Blobs

open System

let connectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage")

let serviceClient = BlobServiceClient(connectionString)

let searchClause = "@container = 'samples-workitems'"

let containers = serviceClient.GetBlobContainers() // works correctly
let results = serviceClient.FindBlobsByTags(searchClause) // returns an http 400 error