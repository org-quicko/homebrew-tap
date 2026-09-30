# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.5.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.5.0/silo-1.5.0-darwin-arm64.tar.gz"
      sha256 "91e4ed7e66a808626e9a6994c97c98f6d6dbf13a2ad32db829006ba196ad7a3b"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.5.0/silo-1.5.0-darwin-x64.tar.gz"
      sha256 "5e96d4c258eb937c809e531e2b9fa472836a934b961d382094315acd927040ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.5.0/silo-1.5.0-linux-arm64.tar.gz"
      sha256 "08c702822494e29049989e354c0b145d76806499284d9113b871fca5993ac334"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.5.0/silo-1.5.0-linux-x64.tar.gz"
      sha256 "7ecb42638ee8bb48223f50cb77aca37a82710e05bfaa1ba90b00fef2937a8742"
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
