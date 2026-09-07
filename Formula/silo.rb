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
      sha256 "0b4ca5a46b1b78564399c796a0a76dd30738da90905fd5239aa14cb180412b95"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-x64.tar.gz"
      sha256 "aa0ac0185a07c0215881273052f92152deb1cf2cb79e8923070020bccbd2d45d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-arm64.tar.gz"
      sha256 "228d1bfccbca676cd60776b494ddf1ae3cd7bbefe48d90e7c92dd0ea1df0093e"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-x64.tar.gz"
      sha256 "cacfaa921eb1f4ae8a7fc79884182be813eab1a14e92905c2d697c268a8c160d"
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
