/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000201706083_1035674024_init();
    work_m_00000000003997037735_1814517970_init();
    work_m_00000000003051334528_3370108073_init();
    work_m_00000000001889228470_0984947828_init();
    work_m_00000000003043870868_3923416757_init();
    work_m_00000000000201706083_0273213086_init();
    work_m_00000000002315783058_1755980896_init();
    work_m_00000000003997037735_0319792243_init();
    work_m_00000000000399706963_1010895172_init();
    work_m_00000000003180968536_1764545990_init();
    work_m_00000000000862639567_3484791089_init();
    work_m_00000000001018415440_3730198808_init();
    work_m_00000000000996011531_3148384703_init();
    work_m_00000000004132667715_0134585865_init();
    work_m_00000000003560000296_1053802506_init();
    work_m_00000000001236723009_3074937660_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001236723009_3074937660");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}