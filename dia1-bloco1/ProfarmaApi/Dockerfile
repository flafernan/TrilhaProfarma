# ==========================================
# ESTÁGIO 1: Compilação (Build)
# ==========================================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /app

# Copia os arquivos de projeto (.csproj) e restaura as dependências
COPY *.csproj ./
RUN dotnet restore

# Copia o restante dos arquivos do código-fonte e compila em modo Release
COPY . ./
RUN dotnet publish -c Release -o out

# ==========================================
# ESTÁGIO 2: Execução (Runtime) + Healthcheck
# ==========================================
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

COPY --from=build-env /app/out .

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "ProfarmaApi.dll"]