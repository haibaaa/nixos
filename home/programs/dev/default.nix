{pkgs, ...}: {
  home.packages = with pkgs; [
    # Dev languages and environments
    go
    zig
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
