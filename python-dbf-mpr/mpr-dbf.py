import sys
import dbf

table = dbf.Table('./JedUc/DATA0004/FAKPR.DBF')
table.open(dbf.READ_WRITE)
for record in table:
  print(record.CISLO,record.DATVYSTAVE,record.ZAPLATENE)
  tablePol = dbf.Table('./JedUc/DATA0004/FAKPRPOL.DBF')
  tablePol.open(dbf.READ_WRITE)
  for recordPol in tablePol:
    if recordPol.CISLOMR == record.CISLO:
      print(record.CISLO,record.ZAPLATENE,recordPol.TEXT,recordPol.MJ,recordPol.POCETMJ,recordPol.CENAMJ)
      print('--------')

table = dbf.Table('./JedUc/DATA0004/FAKVY.DBF')
table.open(dbf.READ_WRITE)
for record in table:
  print(record.CISLO,record.DATVYSTAVE,record.ZAPLATENE)
  tablePol = dbf.Table('./JedUc/DATA0004/FAKVYPOL.DBF')
  tablePol.open(dbf.READ_WRITE)
  for recordPol in tablePol:
    if recordPol.CISLOMR == record.CISLO:
      print(record.CISLO,record.ZAPLATENE,recordPol.TEXT,recordPol.MJ,recordPol.POCETMJ,recordPol.CENAMJ)
      print('--------')