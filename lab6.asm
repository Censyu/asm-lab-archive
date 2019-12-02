include Irvine32.inc
include macros.inc

.data
zero  REAL8 0.0
xval  REAL8 0.0
tval  REAL8 0.0
.code
main PROC
    finit

    mWrite "Please enter 'x': "
    call    ReadFloat

	call    ShowFPUStack

	fstp xval

    mWrite "Please enter 'a1': "
    call    ReadFloat

	call    ShowFPUStack
	fld xval
	call    ShowFPUStack
	fsqrt
	call    ShowFPUStack
	fmul ST(0), ST(1)
	call    ShowFPUStack
	mWrite "Please enter 'a2': "
    call    ReadFloat

	fld xval
	call    ShowFPUStack
	fyl2x
	call    ShowFPUStack
	fadd ST(0), ST(1)
	call    ShowFPUStack

	mWrite "Please enter 'a3': "
    call    ReadFloat
   
    fld xval
	call    ShowFPUStack
	fsin
	call    ShowFPUStack
	fmul ST(0), ST(1)

	fstp tval
	fstp xval
	fld tval

	call    ShowFPUStack
	fadd ST(0), ST(1)
    call    ShowFPUStack
   
    mWrite "a1 * sqrt(x) + a2log2(x) + a3sin(x) = "
    call    WriteFloat
    call    Crlf
	jmp fin
fail:
	mWrite "Error: x < 0!"
fin:
    exit
main ENDP
END main