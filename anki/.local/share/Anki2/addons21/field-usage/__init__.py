# import the main window object (mw) from aqt
from aqt import mw
# import the "show info" tool from utils.py
from aqt.utils import showInfo
# import all of the Qt GUI library
from aqt.qt import *

import pandas as pd
# We're going to add a menu item below. First we want to create a function to
# be called when the menu item is activated.

def field_usage(note_type="base"):
    # showInfo("Card count: %d" % cardCount)

    # Set `usage_ser`
    # {field : count}
    usage_ser = pd.Series(dtype="uint64")
    ids = mw.col.findNotes("note:base")
    # Setup fields
    nid = ids[0]
    note = mw.col.getNote(nid)
    for name, _ in note.items():
        usage_ser[name] = 0
    # Main calculation
    for nid in ids:
        note = mw.col.getNote(nid)
        for name, value in note.items():
            if value == "":
                continue
            if name in usage_ser:
                usage_ser[name] += 1
            else:
                usage_ser[name] = 1
    usage_ser = usage_ser.sort_values(ascending=False)

    # showInfo(str(len(usage_ser)))
    # showInfo(str(len(ids)))

    # Print `usage_ser`
    result = "Usage statistics:\n\n"
    for field, count in usage_ser.items():
        result += "\n{0}\t\t{1}".format(field, count)

    showInfo(result)
    

# create a new menu item, "test"
action = QAction("Field usage", mw)
# set it to call testFunction when it's clicked
action.triggered.connect(field_usage)
# and add it to the tools menu
mw.form.menuTools.addAction(action)
