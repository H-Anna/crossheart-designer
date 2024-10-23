#include <stdio.h>

#include <hpdf.h>
#include <setjmp.h>

jmp_buf env;

void error_handler(HPDF_STATUS error_no,
    HPDF_STATUS detail_no,
    void* user_data)
{
    printf("ERROR: error_no=%04X, detail_no=%u\n", (HPDF_UINT)error_no,
        (HPDF_UINT)detail_no);
    longjmp(env, 1);
}

int main()
{
    HPDF_Doc pdf;

    pdf = HPDF_New(error_handler, NULL);
    if (!pdf) {
        printf("ERROR: cannot create pdf object.\n");
        return 1;
    }

    if (setjmp(env)) {
        HPDF_Free(pdf);
        return 1;
    }

    HPDF_SaveToFile(pdf, "test.pdf");
    HPDF_Free(pdf);
}