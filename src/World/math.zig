pub fn clamp(num: f32, min: f32, max: f32) f32 {
    if (min > max) unreachable;

    return @max(min, @min(max, num));
}

/// Fast square root approximation by John Carmack
/// https://en.wikipedia.org/wiki/Fast_inverse_square_root
pub fn sqrt(num: f32) f32 {
    var i: i32 = undefined;
    var x: f32 = undefined;
    var y: f32 = undefined;

    x = num * 0.5;
    y = num;
    i = @as(*i32, @ptrCast(&y)).*;
    i = 0x5f3759df - (i >> 1);
    y = @as(*f32, @ptrCast(&i)).*;
    y = y * (1.5 - (x * y * y));
    y = y * (1.5 - (x * y * y));

    return num * y;
}

/// Fast random number generator by Lehmer
/// https://en.wikipedia.org/wiki/Lehmer_random_number_generator
pub fn rand() u64 {
    s = s +% 0xe120fc15;

    // Short for magic
    var M: u64 = s *% 0x4a39b70d;
    const m1: u64 = (M >> 32) ^ M;
    M = m1 *% 0x12fad5c9;
    const m2: u64 = (M >> 32) ^ M;

    return m2;
}

/// Short for seed
/// Is used to generate random numbers
var s: u64 = undefined;

/// Is used to initialize the Lehmer random number generator
/// Not calling this before using `rand` is undefined behavior
pub fn seed(newSeed: u64) void {
    s = newSeed;
}
