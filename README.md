
Run the docker image:

```
./startdocker.sh
```

Get this error:

```
  Errors in /app/paket-constrain-framework.fsproj
      Package System.Security.Cryptography.OpenSsl 4.4.0 is not compatible with net462 (.NETFramework,Version=v4.6.2). Package System.Security.Cryptography.OpenSsl 4.4.0 supports:
        - netcoreapp2.0 (.NETCoreApp,Version=v2.0)
        - netstandard1.6 (.NETStandard,Version=v1.6)
        - netstandard2.0 (.NETStandard,Version=v2.0)
      One or more packages are incompatible with .NETFramework,Version=v4.6.2.
```


* Rename `paket-constrain-framework.fsproj` to `paket-constrain-framework.fsproj.bak`
* Rename `paket-constrain-framework.fsproj.nuget` to `paket-constrain-framework.fsproj`

Run the docker image:

```
./startdocker.sh
```

No error