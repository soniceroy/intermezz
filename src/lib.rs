#![feature(lang_items)]
#![feature(panic_implementation)]
#![no_std]

use core:: panic::PanicInfo;

#[lang = "eh_personality"]
extern fn eg_personality() {

}

#[panic_implementation]
#[no_mangle]
pub extern fn panic(_info: &PanicInfo) -> ! {
	loop {}
}

#[no_mangle]
pub extern fn kmain() -> ! {
	unsafe {
		let vga = 0xb8000 as *mut u64;

		*vga = 0x2f592f412f4b2f4f;
	}
	loop {}
}