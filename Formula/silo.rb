# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.6.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.0/silo-1.6.0-darwin-arm64.tar.gz"
      sha256 "97970cffc98312f190a0bec26dd168bb493df1b23fdaa45e175e4cd23eb48cff"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.0/silo-1.6.0-darwin-x64.tar.gz"
      sha256 "ff84bb76eea75a8737fc593d2af56465ee538959336d3030ee40ba15217c9242"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.0/silo-1.6.0-linux-arm64.tar.gz"
      sha256 "73c9af5cfa213187fccf2389c617ecc4696b7a396e9438d03a0e2d764cb24c1a"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.0/silo-1.6.0-linux-x64.tar.gz"
      sha256 "bd0b875a9c4300dcdefb30151b37cdb08d55160ecf89271a4f34371f4aa83c2d"
    end
  end

  livecheck do
    url :homepage
    strategy :github_latest
  end

  def install
    bin.install "silo"
  end

  # `brew services` starts silo with an explicit data directory, because the
  # default is `./silo_data` relative to the working directory and a service has
  # no meaningful one. Everything a run produces — database, media, log — then
  # lives under Homebrew's prefix instead of wherever the user last stood.
  def post_install
    (var/"silo").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"silo", "serve", "--data", var/"silo", "--log-file", var/"log/silo.log"]
    keep_alive true
    working_dir var/"silo"
    log_path var/"log/silo.log"
    error_log_path var/"log/silo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/silo version")

    # Offline, and it exercises the parts a broken build breaks first: argv
    # parsing, the config writer, and the filesystem.
    system bin/"silo", "init", "--config", testpath/"silo.toml"
    assert_path_exists testpath/"silo.toml"
  end
end
