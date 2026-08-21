# GENERATED from packaging/homebrew/silo.rb.tmpl by scripts/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "0.1.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v0.1.0/silo-0.1.0-darwin-arm64.tar.gz"
      sha256 "8f84ae92644cf2834a450f182270a781f2c0eb67f660e1b1291e224517492d22"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v0.1.0/silo-0.1.0-darwin-x64.tar.gz"
      sha256 "e6ea5fc37ef98fbaef90d8ae47b5b0467dff98189078718e7fb02a38a1814304"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v0.1.0/silo-0.1.0-linux-arm64.tar.gz"
      sha256 "49167c01b42aaf59ba78f42d9f0cc288a03af69bbeae3dd802511f8c14e9b098"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v0.1.0/silo-0.1.0-linux-x64.tar.gz"
      sha256 "e0460e2ceefcded556a0c4107d962273e0e0e5ddada40ee8de858e3e6ba10b4d"
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
