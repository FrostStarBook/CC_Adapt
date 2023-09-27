use debug::PrintTrait;

#[derive(Copy, Drop, Serde)]
struct Pack {
    first: felt252,
    second: felt252,
    third: felt252
}

#[generate_trait]
impl PackImpl of PachTrait {
    fn set_bit(ref self: Pack, mut position: u128) {
        if position <= 252 {
            let mut first: felt252 = self.first;
            self.first = (self.first.into() | get_mask(position)).try_into().expect('overflow');
        }
    }
}

#[test]
#[available_gas(3000000)]
fn test() {
    let pack: Pack = Pack { first: 0, second: 0, third: 0 };
    pack.first.print();
}

fn get_mask(position: u128) -> u256 {
    if position <= 126 {
        if position <= 63 {
            if position <= 31 {
                if position <= 15 {
                    if position <= 7 {
                        if position <= 3 {
                            if position == 1 {
                                MASK_1
                            } else if position == 2 {
                                MASK_2
                            } else {
                                MASK_3
                            }
                        } else {
                            if position == 4 {
                                MASK_4
                            } else if position == 5 {
                                MASK_5
                            } else if position == 6 {
                                MASK_6
                            } else {
                                MASK_7
                            }
                        }
                    } else {
                        if position <= 11 {
                            if position == 8 {
                                MASK_8
                            } else if position == 9 {
                                MASK_9
                            } else if position == 10 {
                                MASK_10
                            } else {
                                MASK_11
                            }
                        } else {
                            if position == 12 {
                                MASK_12
                            } else if position == 13 {
                                MASK_13
                            } else if position == 14 {
                                MASK_14
                            } else {
                                MASK_15
                            }
                        }
                    }
                } else {
                    if position <= 23 {
                        if position <= 17 {
                            if position <= 11 {
                                if position == 12 {
                                    MASK_12
                                } else if position == 13 {
                                    MASK_13
                                } else if position == 14 {
                                    MASK_14
                                } else {
                                    MASK_15
                                }
                            } else {
                                if position == 16 {
                                    MASK_16
                                } else {
                                    MASK_17
                                }
                            }
                        } else {
                            if position <= 21 {
                                if position == 18 {
                                    MASK_18
                                } else if position == 19 {
                                    MASK_19
                                } else if position == 20 {
                                    MASK_20
                                } else {
                                    MASK_21
                                }
                            } else {
                                if position == 22 {
                                    MASK_22
                                } else {
                                    MASK_23
                                }
                            }
                        }
                    } else {
                        if position <= 31 {
                            if position <= 27 {
                                if position == 24 {
                                    MASK_24
                                } else if position == 25 {
                                    MASK_25
                                } else if position == 26 {
                                    MASK_26
                                } else {
                                    MASK_27
                                }
                            } else {
                                if position == 28 {
                                    MASK_28
                                } else if position == 29 {
                                    MASK_29
                                } else if position == 30 {
                                    MASK_30
                                } else {
                                    MASK_31
                                }
                            }
                        } else {
                            if position <= 39 {
                                if position <= 35 {
                                    if position == 32 {
                                        MASK_32
                                    } else if position == 33 {
                                        MASK_33
                                    } else if position == 34 {
                                        MASK_34
                                    } else {
                                        MASK_35
                                    }
                                } else {
                                    if position == 36 {
                                        MASK_36
                                    } else if position == 37 {
                                        MASK_37
                                    } else if position == 38 {
                                        MASK_38
                                    } else {
                                        MASK_39
                                    }
                                }
                            } else {
                                if position <= 47 {
                                    if position <= 43 {
                                        if position == 40 {
                                            MASK_40
                                        } else if position == 41 {
                                            MASK_41
                                        } else if position == 42 {
                                            MASK_42
                                        } else {
                                            MASK_43
                                        }
                                    } else {
                                        if position == 44 {
                                            MASK_44
                                        } else if position == 45 {
                                            MASK_45
                                        } else if position == 46 {
                                            MASK_46
                                        } else {
                                            MASK_47
                                        }
                                    }
                                } else {
                                    if position <= 55 {
                                        if position <= 51 {
                                            if position == 48 {
                                                MASK_48
                                            } else if position == 49 {
                                                MASK_49
                                            } else if position == 50 {
                                                MASK_50
                                            } else {
                                                MASK_51
                                            }
                                        } else {
                                            if position == 52 {
                                                MASK_52
                                            } else if position == 53 {
                                                MASK_53
                                            } else if position == 54 {
                                                MASK_54
                                            } else {
                                                MASK_55
                                            }
                                        }
                                    } else {
                                        if position <= 63 {
                                            if position <= 59 {
                                                if position == 56 {
                                                    MASK_56
                                                } else if position == 57 {
                                                    MASK_57
                                                } else if position == 58 {
                                                    MASK_58
                                                } else {
                                                    MASK_59
                                                }
                                            } else {
                                                if position == 60 {
                                                    MASK_60
                                                } else if position == 61 {
                                                    MASK_61
                                                } else if position == 62 {
                                                    MASK_62
                                                } else {
                                                    MASK_63
                                                }
                                            }
                                        } else {}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


const MASK_1: u256 = 0x1;
const MASK_2: u256 = 0x3;
const MASK_3: u256 = 0x7;
const MASK_4: u256 = 0xF;
const MASK_5: u256 = 0x1F;
const MASK_6: u256 = 0x3F;
const MASK_7: u256 = 0x7F;
const MASK_8: u256 = 0xFF;
const MASK_9: u256 = 0x1FF;
const MASK_10: u256 = 0x3FF;
const MASK_11: u256 = 0x7FF;
const MASK_12: u256 = 0xFFF;
const MASK_13: u256 = 0x1FFF;
const MASK_14: u256 = 0x3FFF;
const MASK_15: u256 = 0x7FFF;
const MASK_16: u256 = 0xFFFF;
const MASK_17: u256 = 0x1FFFF;
const MASK_18: u256 = 0x3FFFF;
const MASK_19: u256 = 0x7FFFF;
const MASK_20: u256 = 0xFFFFF;
const MASK_21: u256 = 0x1FFFFF;
const MASK_22: u256 = 0x3FFFFF;
const MASK_23: u256 = 0x7FFFFF;
const MASK_24: u256 = 0xFFFFFF;
const MASK_25: u256 = 0x1FFFFFF;
const MASK_26: u256 = 0x3FFFFFF;
const MASK_27: u256 = 0x7FFFFFF;
const MASK_28: u256 = 0xFFFFFFF;
const MASK_29: u256 = 0x1FFFFFFF;
const MASK_30: u256 = 0x3FFFFFFF;
const MASK_31: u256 = 0x7FFFFFFF;
const MASK_32: u256 = 0xFFFFFFFF;
const MASK_33: u256 = 0x1FFFFFFFF;
const MASK_34: u256 = 0x3FFFFFFFF;
const MASK_35: u256 = 0x7FFFFFFFF;
const MASK_36: u256 = 0xFFFFFFFFF;
const MASK_37: u256 = 0x1FFFFFFFFF;
const MASK_38: u256 = 0x3FFFFFFFFF;
const MASK_39: u256 = 0x7FFFFFFFFF;
const MASK_40: u256 = 0xFFFFFFFFFF;
const MASK_41: u256 = 0x1FFFFFFFFFF;
const MASK_42: u256 = 0x3FFFFFFFFFF;
const MASK_43: u256 = 0x7FFFFFFFFFF;
const MASK_44: u256 = 0xFFFFFFFFFFF;
const MASK_45: u256 = 0x1FFFFFFFFFFF;
const MASK_46: u256 = 0x3FFFFFFFFFFF;
const MASK_47: u256 = 0x7FFFFFFFFFFF;
const MASK_48: u256 = 0xFFFFFFFFFFFF;
const MASK_49: u256 = 0x1FFFFFFFFFFFF;
const MASK_50: u256 = 0x3FFFFFFFFFFFF;
const MASK_51: u256 = 0x7FFFFFFFFFFFF;
const MASK_52: u256 = 0xFFFFFFFFFFFFF;
const MASK_53: u256 = 0x1FFFFFFFFFFFFF;
const MASK_54: u256 = 0x3FFFFFFFFFFFFF;
const MASK_55: u256 = 0x7FFFFFFFFFFFFF;
const MASK_56: u256 = 0xFFFFFFFFFFFFFF;
const MASK_57: u256 = 0x1FFFFFFFFFFFFFF;
const MASK_58: u256 = 0x3FFFFFFFFFFFFFF;
const MASK_59: u256 = 0x7FFFFFFFFFFFFFF;
const MASK_60: u256 = 0xFFFFFFFFFFFFFFF;
const MASK_61: u256 = 0x1FFFFFFFFFFFFFFF;
const MASK_62: u256 = 0x3FFFFFFFFFFFFFFF;
const MASK_63: u256 = 0x7FFFFFFFFFFFFFFF;
const MASK_64: u256 = 0xFFFFFFFFFFFFFFFF;
const MASK_65: u256 = 0x1FFFFFFFFFFFFFFFF;
const MASK_66: u256 = 0x3FFFFFFFFFFFFFFFF;
const MASK_67: u256 = 0x7FFFFFFFFFFFFFFFF;
const MASK_68: u256 = 0xFFFFFFFFFFFFFFFFF;
const MASK_69: u256 = 0x1FFFFFFFFFFFFFFFFF;
const MASK_70: u256 = 0x3FFFFFFFFFFFFFFFFF;
const MASK_71: u256 = 0x7FFFFFFFFFFFFFFFFF;
const MASK_72: u256 = 0xFFFFFFFFFFFFFFFFFF;
const MASK_73: u256 = 0x1FFFFFFFFFFFFFFFFFF;
const MASK_74: u256 = 0x3FFFFFFFFFFFFFFFFFF;
const MASK_75: u256 = 0x7FFFFFFFFFFFFFFFFFF;
const MASK_76: u256 = 0xFFFFFFFFFFFFFFFFFFF;
const MASK_77: u256 = 0x1FFFFFFFFFFFFFFFFFFF;
const MASK_78: u256 = 0x3FFFFFFFFFFFFFFFFFFF;
const MASK_79: u256 = 0x7FFFFFFFFFFFFFFFFFFF;
const MASK_80: u256 = 0xFFFFFFFFFFFFFFFFFFFF;
const MASK_81: u256 = 0x1FFFFFFFFFFFFFFFFFFFF;
const MASK_82: u256 = 0x3FFFFFFFFFFFFFFFFFFFF;
const MASK_83: u256 = 0x7FFFFFFFFFFFFFFFFFFFF;
const MASK_84: u256 = 0xFFFFFFFFFFFFFFFFFFFFF;
const MASK_85: u256 = 0x1FFFFFFFFFFFFFFFFFFFFF;
const MASK_86: u256 = 0x3FFFFFFFFFFFFFFFFFFFFF;
const MASK_87: u256 = 0x7FFFFFFFFFFFFFFFFFFFFF;
const MASK_88: u256 = 0xFFFFFFFFFFFFFFFFFFFFFF;
const MASK_89: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFF;
const MASK_90: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFF;
const MASK_91: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFF;
const MASK_92: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_93: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFF;
const MASK_94: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFF;
const MASK_95: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFF;
const MASK_96: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_97: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_98: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_99: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_100: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_101: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_102: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_103: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_104: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_105: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_106: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_107: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_108: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_109: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_110: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_111: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_112: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_113: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_114: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_115: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_116: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_117: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_118: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_119: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_120: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_121: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_122: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_123: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_124: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_125: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_126: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_127: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_128: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_129: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_130: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_131: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_132: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_133: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_134: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_135: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_136: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_137: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_138: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_139: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_140: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_141: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_142: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_143: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_144: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_145: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_146: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_147: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_148: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_149: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_150: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_151: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_152: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_153: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_154: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_155: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_156: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_157: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_158: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_159: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_160: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_161: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_162: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_163: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_164: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_165: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_166: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_167: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_168: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_169: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_170: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_171: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_172: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_173: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_174: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_175: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_176: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_177: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_178: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_179: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_180: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_181: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_182: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_183: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_184: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_185: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_186: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_187: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_188: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_189: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_190: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_191: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_192: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_193: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_194: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_195: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_196: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_197: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_198: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_199: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_200: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_201: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_202: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_203: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_204: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_205: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_206: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_207: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_208: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_209: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_210: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_211: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_212: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_213: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_214: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_215: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_216: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_217: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_218: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_219: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_220: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_221: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_222: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_223: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_224: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_225: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_226: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_227: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_228: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_229: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_230: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_231: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_232: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_233: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_234: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_235: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_236: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_237: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_238: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_239: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_240: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_241: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_242: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_243: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_244: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_245: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_246: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_247: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_249: u256 = 0x1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_250: u256 = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_251: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MASK_252: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
