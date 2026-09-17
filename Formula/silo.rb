# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.2.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.2.0/silo-1.2.0-darwin-arm64.tar.gz"
      sha256 "80d1cf8bd99b7e46292da1b279e5501a824cf1ed2be3afdc257bd8b375f9f26d"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.2.0/silo-1.2.0-darwin-x64.tar.gz"
      sha256 "dd44fee396a79951ab44092a299a2af140b9c975fc9754230da74c8e9b0d4316"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.2.0/silo-1.2.0-linux-arm64.tar.gz"
      sha256 "9d87a71eb072b277b6054cf19a09d4119933c6708f2319612f102eab87aaa427"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.2.0/silo-1.2.0-linux-x64.tar.gz"
      sha256 "a9c1c8e3c19c3ad939f945fd988fc14bd5653e91ee5f1fc418088355b0ce0a31"
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
