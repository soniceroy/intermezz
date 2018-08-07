#![feature(lang_items)]
#![feature(panic_implementation)]
#![no_std]

use core:: panic::PanicInfo;

#[lang = "eh_personality"]
extern fn eg_personality() {

}

#[panic_implementation]
extern fn panic(_info: &PanicInfo) -> ! {
	loop {}
}

