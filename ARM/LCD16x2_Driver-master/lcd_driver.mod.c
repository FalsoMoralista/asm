#include <linux/build-salt.h>
#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

BUILD_SALT;

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0xad1a7def, "module_layout" },
	{ 0x1d11aa3a, "cdev_del" },
	{ 0x38ef651b, "device_destroy" },
	{ 0x88647e86, "cdev_add" },
	{ 0x7a3acc89, "cdev_init" },
	{ 0xb4673642, "cdev_alloc" },
	{ 0xe30a435, "class_destroy" },
	{ 0x765f4408, "device_create" },
	{ 0x6091b333, "unregister_chrdev_region" },
	{ 0xd15f066d, "__class_create" },
	{ 0xe3ec2f2b, "alloc_chrdev_region" },
	{ 0x37a0cba, "kfree" },
	{ 0x12da5bb2, "__kmalloc" },
	{ 0xfe990052, "gpio_free" },
	{ 0xee90f06e, "gpiod_unexport" },
	{ 0xe31620ea, "gpiod_direction_output_raw" },
	{ 0xddaa5251, "gpiod_export" },
	{ 0x47229b5c, "gpio_request" },
	{ 0xdb7305a1, "__stack_chk_fail" },
	{ 0x5f754e5a, "memset" },
	{ 0x28cc25db, "arm_copy_from_user" },
	{ 0x8f678b07, "__stack_chk_guard" },
	{ 0xffb0dcd9, "gpiod_set_raw_value" },
	{ 0x350a004, "gpio_to_desc" },
	{ 0x12a38747, "usleep_range" },
	{ 0x2e5810c6, "__aeabi_unwind_cpp_pr1" },
	{ 0x7c32d0f0, "printk" },
	{ 0xb1ad28e0, "__gnu_mcount_nc" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "A1D711442F241A0EF9D08BF");
