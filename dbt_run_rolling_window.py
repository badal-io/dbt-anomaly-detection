import os
import datetime

def daterange(start_date, end_date):
    for n in range(int((end_date - start_date).days) + 1):
        yield start_date + datetime.timedelta(n)

def main():
    start_date = datetime.date(2023, 1, 29)
    end_date = datetime.date(2023, 2, 9)

    for date in daterange(start_date, end_date):
        date_str = date.strftime('%Y-%m-%d')
        print("Running dbt models for start_date: {}".format(date_str))
        os.system("dbt run --vars '{{start_date: \"{}\"}}'".format(date_str))

if __name__ == "__main__":
    main()
