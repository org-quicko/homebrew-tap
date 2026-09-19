# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.3.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.3.0/silo-1.3.0-darwin-arm64.tar.gz"
      sha256 "fdd9dcf7eaba162e78704b2fc54aacba4fd44ac9208c9882838c786ea638171a"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.3.0/silo-1.3.0-darwin-x64.tar.gz"
      sha256 "862b74b27912fc3897643f4692bc9795f26425e1294674a5d29fb4567bac9c2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.3.0/silo-1.3.0-linux-arm64.tar.gz"
      sha256 "4b11b319a47eb0c520cdb468ffde3072de79f53b59bd8c99a01c9f0845087dd5"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.3.0/silo-1.3.0-linux-x64.tar.gz"
      sha256 "37f716512e576d7d0b8e5ab524dc8f806f0bc6f1a11951838a2a4767ea067a8d"
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
