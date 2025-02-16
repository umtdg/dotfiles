python
from pathlib import Path
home = Path.home()
gdb.execute(f"source {home}/.gdbinit-gef.py")
