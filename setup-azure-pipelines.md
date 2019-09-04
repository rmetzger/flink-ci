# How to setup Azure Pipelines for your fork?

1. Go to https://dev.azure.com
2. Click "Start free with GitHub" & authroize (connect your exising msft account & create an email. No password required)
3. Create a public project
4. Click on "Pipelines" (either on the left nav bar, or in the "Welcome to the project! / What service would you like to start with?" box)
5. Click "New Pipeline", select "GitHub" as your code location, authorize AzurePipelines, select your Flink repository fork, approve code access, it will detect that there's already an `azure-pipelines.yml` definition.
6. Press "Run"