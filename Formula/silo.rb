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
      sha256 "dd100bbe90dbda1d95cc3e0208d6e8a23fdc9aff6ea50d282bece7d5faf5fb6d"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-x64.tar.gz"
      sha256 "d41e8be80fcf5c34836a23f51ba3fbeeabb094004554cc932b7b29848ebaa4f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-arm64.tar.gz"
      sha256 "22468c623f94a6d9b13fb3f994c10c2de65a6cc6a24877fa276ea0e329c90685"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-x64.tar.gz"
      sha256 "926165a2dbf92dd42b769c430289cac95b7539ee91a108776361e273b80c9639"
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
