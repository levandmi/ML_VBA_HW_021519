Attribute VB_Name = "Module1"
Sub totalstock():
    Dim numrows As Long
    Dim rowstart As Integer
    
    
    'finding amount of worksheets for challenge'
    Dim WS_Count As Integer
    WS_Count = ActiveWorkbook.Worksheets.Count
    
    'added forloop for moving through worksheets'
    For X = 1 To WS_Count
    
    
        Worksheets(X).Activate
        'setting column names'
        Cells(1, 9).Value = "Ticker"
        Cells(1, 10).Value = "Yearly Change"
        Cells(1, 11).Value = "Percent Change"
        Cells(1, 12).Value = "Total Stock Volume"
        'setting range of rows with text'
        numrows = Range("A1", Range("A1").End(xlDown)).Rows.Count
 
        rowstart = 1
    
        For i = 2 To numrows
            'if new ticker, start filling in grouped tickers'
            If Cells(i, 1).Value <> Cells(i - 1, 1).Value Then
                rowstart = rowstart + 1
                Cells(rowstart, 9).Value = Cells(i, 1).Value
                Cells(rowstart, 12).Value = Cells(i, 7).Value
                'store opening date open value to variable'
                stockopenyear = Cells(i, 3).Value
            'find stock end of year close value and save to variable THIS WILL ALSO USE THIS ROWS VOLUME'
            ElseIf Cells(i, 1).Value <> Cells(i + 1, 1).Value Then
                stockcloseyear = Cells(i, 6).Value
                amounttot = Cells(rowstart, 12).Value
                amounttot = amounttot + Cells(i, 7).Value
                Cells(rowstart, 12).Value = amounttot
            'if same ticker combine volume to previous amount'
            ElseIf Cells(i, 1).Value = Cells(i - 1, 1).Value Then
                amounttot = Cells(rowstart, 12).Value
                amounttot = amounttot + Cells(i, 7).Value
                Cells(rowstart, 12).Value = amounttot

            End If
            'calculate yearly change and add formatting'
            yearlychange = stockcloseyear - stockopenyear
            Cells(rowstart, 10).Value = yearlychange
            'coloring yearly change cells'
            If yearlychange < 0 Then
                Cells(rowstart, 10).Interior.ColorIndex = 3
            Else
                Cells(rowstart, 10).Interior.ColorIndex = 4
            End If
            
            
            'calculate the percent change'
            'zero percent division exclusion'
            If stockopenyear = 0 Then
                Cells(rowstart, 11).Value = "NA"
            Else
                percentchange = yearlychange / stockopenyear
                Cells(rowstart, 11).Value = percentchange
            End If
        
        Next i
    
        'convert percentage column to display percentages'
        Range("K2", Range("K2").End(xlDown)).NumberFormat = "0.00%"
    
        'label greatest boxes'
        Cells(2, 15).Value = "Greatest % Increase"
        Cells(3, 15).Value = "Greatest % Decrease"
        Cells(4, 15).Value = "Greatest Total Volume"
        Cells(1, 16).Value = "Ticker"
        Cells(1, 17).Value = "Value"
        

        'Check to make sure the greatest changes loops are using the correct column.'
        If Range("K1").Value <> "Percent Change" Then
            MsgBox ("Greatest percent changes is using the wrong column.")
        End If
    
        'range for greatest % increase'
        greatestrange = Range("K1", Range("K1").End(xlDown)).Rows.Count
    
        'for loop for greatest % increase'
        'NOTE the cells need to be blank, which they should.  If the spreadsheet is being re-used, which it shouldn't be, there will already be data in the cells.  I could start this with a funciton to clear the destination cell of all the data, but I'm already this far into writing a note, and I think it's pretty clear I could do that if I had to.  My lazyness knows no bounds.  If you've read the comment this far, go out and get some fresh air, and a snack.  You deserve it!'
        Range("Q2").Clear
        'I slept on it, and I felt like I should be thorough and put in a clear cell function.  I made the conscious decision to leave the previous comment in, just so you TAs could see the emotion battle this was.  One man and his supreme desire to be lazy against his inner need to pass the class so that his company might pay for it.  I mean that's what coding is right?  A way to do more work with less effort?'
        For i = 2 To greatestrange
            'If there is an NA to avoid the div by zero error, just like move along man.  Maybe it'll be your time next year, little stock that could.'
            If Cells(i, 11).Value = "NA" Then
                Cells(i, 11).Value = "NA"
            'test to see if greatest cell value empty'
            ElseIf IsEmpty(Range("Q2").Value) = True Then
                Range("Q2").Value = Cells(i, 11).Value
                Range("P2").Value = Cells(i, 9).Value
            ElseIf Cells(i, 11).Value > Range("Q2").Value Then
                Range("Q2").Value = Cells(i, 11).Value
                Range("P2").Value = Cells(i, 9).Value
            End If
        Next i
    
        'for loop for greatest % decrease'
        Range("Q3").Clear
        For i = 2 To greatestrange
            'test to see if greatest cell value empty'
            If IsEmpty(Range("Q3").Value) = True Then
                Range("Q3").Value = Cells(i, 11).Value
                Range("P3").Value = Cells(i, 9).Value
            ElseIf Cells(i, 11).Value < Range("Q3").Value Then
                Range("Q3").Value = Cells(i, 11).Value
                Range("P3").Value = Cells(i, 9).Value
            End If
        Next i
    
        'Check to make sure the greatest changes loops are using the correct column.'
        If Range("L1").Value <> "Total Stock Volume" Then
            MsgBox ("Greatest volume is using the wrong column.")
        End If
        'convert percentage column to display percentages'
        Range("Q2:Q3").NumberFormat = "0.00%"
        'for loop for greatest total volume'
        Range("Q4").Clear
        For i = 2 To greatestrange
            'test to see if greatest cell value empty'
            If IsEmpty(Range("Q4").Value) = True Then
                Range("Q4").Value = Cells(i, 12).Value
                Range("P4").Value = Cells(i, 9).Value
            ElseIf Cells(i, 12).Value > Range("Q4").Value Then
                Range("Q4").Value = Cells(i, 12).Value
                Range("P4").Value = Cells(i, 9).Value
            End If
        Next i
    Next X
        
End Sub



