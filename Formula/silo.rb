# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.0.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-arm64.tar.gz"
      sha256 "bfe69728a0ce61c9674c2e6e575c3cf9dd48fdb9f1d54afba94cc6deab220a6a"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-x64.tar.gz"
      sha256 "ccd20f15f1734065a18565c399f48c120f8edecb96703eb5262c72b7ec71df54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-arm64.tar.gz"
      sha256 "09ea8222f38fdc4282df79c906e1f1cc044241898dfefc3756f6af700b912343"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-x64.tar.gz"
      sha256 "ab45675da018125d6e7a9d8413968e5c04529a195ac80ef2e511dee50c717ce1"
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
