# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.1.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.1.0/silo-1.1.0-darwin-arm64.tar.gz"
      sha256 "f37bd0c043209b52549caa3157d1be0034919af9ede09228f16fbe24c446b44d"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.1.0/silo-1.1.0-darwin-x64.tar.gz"
      sha256 "5a39026046304a88641adfa1c0666f0c88c1473a3a0da55155bc3e9b43eea67d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.1.0/silo-1.1.0-linux-arm64.tar.gz"
      sha256 "f6b8dfd3087ad7f865b529af4f8bb52142b6885396d5b2087b60ad85a2856604"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.1.0/silo-1.1.0-linux-x64.tar.gz"
      sha256 "4ba8498f39e6fd0cf857f667b638f06205508be2cf38825eff510082824ebc68"
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
