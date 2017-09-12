#!/usr/bin/env bash
export FrameworkPathOverride=$(dirname $(which mono))/../lib/mono/4.5/
dotnet restore && dotnet build
