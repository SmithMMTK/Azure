# Dotnet Core Development

## Create New Application

```bash
mkdir apptest1
cd apptest1
dotnet new console
dotnet add package Figgle
```

## Modify code 
```c#
using System;

namespace apptest1
{
    class Program
    {
        static void Main(string[] args)
        {
            string text;
            if (args.Length == 0)
                text = "Hello, World!";
            else
            {
                text = args[0];
            }
            Console.WriteLine(Figgle.FiggleFonts.Standard.Render(text));
        }
    }
}
```

## Run to see result
```bash
dotnet run
```

[.NET Core RID Catalog](https://docs.microsoft.com/en-us/dotnet/core/rid-catalog)
RID is short for Runtime IDentifier. RID values are used to identify target platforms where the application runs. They're used by .NET packages to represent platform-specific assets in NuGet packages. The following values are examples of RIDs: linux-x64, ubuntu.14.04-x64, win7-x64, or osx.10.12-x64. For the packages with native dependencies, the RID designates on which platforms the package can be restored.


## Create Self-contained application
```bash
dotnet publish -f netcoreapp2.2 -r osx-x64 --self-contained
```


---
### dotnet cheat sheet

```bash
dotnet new console
dotnet restore
dotnet publish
dotnet build
dotnet run
dotnet app.dll

dotnet add package Microsoft.Azure.ServiceBus --version 3.4.0
dotnet add package Microsoft.CSharp
dotnet add package Newtonsoft.Json
dotnet add package Figgle
```

```xml
<PackageReference Include="WindowsAzure.ServiceBus" Version="4.1.3" />
<PackageReference Include="Microsoft.CSharp" Version="4.4.0" />
<PackageReference Include="Newtonsoft.Json" Version="10.0.3" />
<PackageReference Include="System.Diagnostics.Debug" Version="4.3.0" />
<PackageReference Include="System.Linq" Version="4.3.0" />
```