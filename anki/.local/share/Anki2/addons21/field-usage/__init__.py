# import the main window object (mw) from aqt
from aqt import mw
# import the "show info" tool from utils.py
from aqt.utils import showInfo
# import all of the Qt GUI library
from aqt.qt import *

from collections import OrderedDict
from operator import itemgetter
# We're going to add a menu item below. First we want to create a function to
# be called when the menu item is activated.

def field_usage(note_type="base"):
    # showInfo("Card count: %d" % cardCount)

    # Set `usage_d` : {field : count}
    usage_d = {}
    ids = mw.col.findNotes("note:{}".format(note_type))
    for nid in ids:
        note = mw.col.getNote(nid)
        for name, value in note.items():
            if value == "":
                continue
            if name in usage_d:
                usage_d[name] += 1
            else:
                usage_d[name] = 1
    
    usage_od = OrderedDict(sorted(usage_d.items(), key=itemgetter(1),
                                  reverse=True))
    result = "Usage statistics:\n\n"
    for field, count in usage_od.items():
        result += "\n{0}\t\t{1}".format(field, count)

    showInfo(result)
    

# create a new menu item, "test"
action = QAction("Field usage", mw)
# set it to call testFunction when it's clicked
action.triggered.connect(lambda: field_usage("base"))
# and add it to the tools menu
mw.form.menuTools.addAction(action)
