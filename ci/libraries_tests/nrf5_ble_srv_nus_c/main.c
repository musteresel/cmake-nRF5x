#include "ble_nus_c.h"

void app_error_handler_bare(uint32_t error_code)
{
}

int main()
{
    ble_nus_c_t nus;
    ble_nus_c_init_t nus_init;
    ble_nus_c_init(&nus, &nus_init);
    return 0;
}