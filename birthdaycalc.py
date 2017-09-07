from datetime import date; from dateutil.relativedelta import *
from dateutil.parser import parse; import sys

print relativedelta(date.today(), parse(sys.argv[2])).years