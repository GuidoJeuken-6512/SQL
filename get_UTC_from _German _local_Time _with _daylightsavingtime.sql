IF NOT OBJECT_ID('dbo.fnGetUTCfromLocalTimeDE', 'FN') IS NULL
  DROP FUNCTION dbo.fnGetUTCfromLocalTimeDE
 GO
 create function dbo.fnGetUTCfromLocalTimeDE
     (@localTimeDE datetime)
     Returns datetime
 as
 Begin
 --this function can easily be adopted for other countries if the start and end times of daylight saving time as well as timezone settings are changed in the function
 Declare @UtcTime datetime
 Declare @Year as int
 Declare @Time as time
 Declare @DlsStartDate as datetime
 Declare @DlsEndDate as datetime
 Declare @DlsStartTime as time = '2:00:00'
 Declare @DlsEndTime as time = '3:00:00'
 Declare @Offset as int = -1 -- + one hour because of the timezone of Germany
 set @Year = DATEPART(YEAR, @localTimeDE)
 -- find start and end date of daylighttime
 ---- in germany daylightsavingtime starts at the last sunday in march at 2 o'clock
 ---- in germany daylightsavingtime ends at the last sunday in october at 3 o'clock
 --earlier exceptions were not taken into account. please refer to: https://de.wikipedia.org/wiki/Sommerzeit#Deutschland
 set @DlsEndDate = dateadd(day, 1- datepart(weekday, datefromparts( @Year, 10, 31)), datefromparts(@Year, 10, 31))
 set @DlsStartDate = dateadd(day, 1- datepart(weekday, datefromparts( @Year, 3, 31)), datefromparts(@Year, 3, 31))
 set @DlsEndDate = @DlsEndDate + convert(datetime, @DlsEndTime)
 set @DlsStartDate = @DlsStartDate + convert(datetime, @DlsStartTime)
 if (@localTimeDE <=@DlsEndDate  and @localTimeDE >= @DlsStartDate) Begin
     set @Offset = @Offset -1 -- is daylitesavingtime
     END
 set @UtcTime = dateadd(hour,@Offset,@localTimeDE) 
 Return @UtcTime
 END --create function
