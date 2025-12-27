"""Run each input through the solution, and compare with a reference."""

import pytest
from pathlib import Path
import subprocess


@pytest.mark.parametrize("day", range(1, 13))
def test_day(day: int):
    root_path = Path(__file__).resolve().parent
    day = f"{day:02}"
    build_folder = root_path / "build"
    example_path = root_path / day / "example.txt"
    expected_path = root_path / day / "expected.txt"
    if not expected_path.exists():
        pytest.skip("reference output not found")
    executable_path = build_folder / f"day{day}.exe"
    if not executable_path.exists():
        pytest.skip("executable not found")
    cmd = [executable_path, example_path]
    result = subprocess.run(cmd, check=True, capture_output=True)
    output = result.stdout.decode("ascii")
    reference = expected_path.read_text()
    assert output == reference
