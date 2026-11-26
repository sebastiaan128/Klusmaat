#!/bin/zsh
set -euo pipefail
repo_root="${0:A:h:h:h}"
perf_dir="$(mktemp -d /tmp/klusmaat-perf.XXXXXX)"
trap 'rm -rf "$perf_dir"' EXIT
cd "$repo_root"
python3 - "$perf_dir/core" <<'PYTHON'
from pathlib import Path
import shutil, sys
package = Path(sys.argv[1])
source = package / "Sources/Klusmaat"
tests = package / "Tests/KlusmaatTests"
source.mkdir(parents=True)
tests.mkdir(parents=True)
(package / "Package.swift").write_text("""// swift-tools-version: 6.2
import PackageDescription
let package = Package(name: "Klusmaat", platforms: [.macOS(.v14)], targets: [
    .target(name: "Klusmaat"), .testTarget(name: "KlusmaatTests", dependencies: ["Klusmaat"])
])
""")
for relative in ["Models/Job.swift", "Models/JobFilters.swift", "Services/JobService.swift",
                 "Services/JobActivity.swift", "Services/JobSearch.swift"]:
    shutil.copy2(Path("Klusmaat") / relative, source / Path(relative).name)
shutil.copy2("KlusmaatTests/ExampleTests.swift", tests / "ExampleTests.swift")
PYTHON
swift test --package-path "$perf_dir/core"
xcrun swiftc -O -parse-as-library \
  Klusmaat/Models/Job.swift Klusmaat/Models/JobFilters.swift \
  Klusmaat/Services/JobService.swift Klusmaat/Services/JobSearch.swift \
  Tools/Performance/SearchBenchmark.swift -o "$perf_dir/search-check"
"$perf_dir/search-check"
if [[ -n "${SIMULATOR_UDID:-}" ]]; then
  sim_sdk="$(xcrun --sdk iphonesimulator --show-sdk-path)"
  sim_version="$(xcrun --sdk iphonesimulator --show-sdk-version)"
  xcrun swiftc -swift-version 5 -default-isolation MainActor -parse-as-library \
    -sdk "$sim_sdk" -target "$(uname -m)-apple-ios${sim_version}-simulator" \
    Klusmaat/Services/ImageRequest.swift Klusmaat/Services/ImageService.swift \
    Tools/Performance/ImagePipelineChecks.swift -o "$perf_dir/image-check"
  xcrun simctl spawn "$SIMULATOR_UDID" "$perf_dir/image-check"
fi
