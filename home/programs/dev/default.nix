{pkgs, ...}: {
  home.packages = with pkgs; [
    # Dev languages and environments
    go
    rustup
    uv
    python3
    jdk25
    bun
    nodejs

    # DB and Engines
    sqlite
    duckdb
    prisma-engines

    # Tooling
    pnpm
    maven
    air
    gnumake
    openssl
  ];
}
