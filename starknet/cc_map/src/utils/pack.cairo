use debug::PrintTrait;

#[derive(Copy, Drop, Serde)]
struct Pack {
    first: felt252,
    second: felt252,
    third: felt252
}

#[generate_trait]
impl PackImpl of PachTrait {
    fn set_bit(ref self: Pack, position: u128) {
        assert(position < 625, 'invalid position');
        if position < 252 {
            self.first = (self.first.into() | get_mask(position)).try_into().expect('bit overflow');
        } else if position < 504 {
            self
                .second = (self.second.into() | get_mask(position % 252))
                .try_into()
                .expect('bit overflow');
        } else {
            self
                .third = (self.third.into() | get_mask(position % 252))
                .try_into()
                .expect('bit overflow');
        }
    }

    fn get_bit(ref self: Pack, position: u128) -> bool {
        assert(position < 625, 'invalid position');
        if position < 252 {
            self.first.into() | get_mask(position) == self.first.into()
        } else if position < 504 {
            self.second.into() | get_mask(position) == self.second.into()
        } else {
            self.third.into() | get_mask(position) == self.third.into()
        }
    }

    fn add_bit(ref self: Pack, other: Pack) {
        let mut result: u256 = self.first.into() | other.first.into();
        self.first = result.try_into().expect('bit overflow');

        result = self.second.into() | other.second.into();
        self.second = result.try_into().expect('bit overflow');

        result = self.third.into() | other.third.into();
        self.third = result.try_into().expect('bit overflow');
    }

    fn subtract_bit(ref self: Pack, other: Pack) {
        let mut result: u256 = self.first.into() & ~other.first.into();
        self.first = result.try_into().expect('bit overflow');

        result = self.second.into() | ~other.second.into();
        self.second = result.try_into().expect('bit overflow');

        result = self.third.into() | ~other.third.into();
        self.third = result.try_into().expect('bit overflow');
    }
//
// fn delete_bit(ref sel: Pack, mut position: u128) {
//     assert(position < 625, 'invalid position');
// }
}

#[test]
#[available_gas(3000000)]
fn test() {
    let pack: Pack = Pack { first: 0, second: 0, third: 0 };
    pack.first.print();
}

#[test]
#[available_gas(3000000)]
fn test_gas1() {
    let pack: Pack = Pack { first: 0, second: 0, third: 0 };
}

#[test]
#[available_gas(3000000)]
fn test_gas2() {
    let pack: Felt252Dict<u128> = Default::default();
}
fn get_mask(position: u128) -> u256 {
    if position <= 126 {
        if position <= 63 {
            if position <= 31 {
                if position <= 15 {
                    if position <= 7 {
                        if position == 0 {
                            0
                        } else if position == 1 {
                            MASK_1
                        } else if position == 2 {
                            MASK_2
                        } else if position == 3 {
                            MASK_3
                        } else if position == 4 {
                            MASK_4
                        } else if position == 5 {
                            MASK_5
                        } else if position == 6 {
                            MASK_6
                        } else {
                            MASK_7
                        }
                    } else {
                        if position == 8 {
                            MASK_8
                        } else if position == 9 {
                            MASK_9
                        } else if position == 10 {
                            MASK_10
                        } else if position == 11 {
                            MASK_11
                        } else if position == 12 {
                            MASK_12
                        } else if position == 13 {
                            MASK_13
                        } else if position == 14 {
                            MASK_14
                        } else {
                            MASK_15
                        }
                    }
                } else {
                    if position <= 23 {
                        if position == 16 {
                            MASK_16
                        } else if position == 17 {
                            MASK_17
                        } else if position == 18 {
                            MASK_18
                        } else if position == 19 {
                            MASK_19
                        } else if position == 20 {
                            MASK_20
                        } else if position == 21 {
                            MASK_21
                        } else if position == 22 {
                            MASK_22
                        } else {
                            MASK_23
                        }
                    } else {
                        if position == 24 {
                            MASK_24
                        } else if position == 25 {
                            MASK_25
                        } else if position == 26 {
                            MASK_26
                        } else if position == 27 {
                            MASK_27
                        } else if position == 28 {
                            MASK_28
                        } else if position == 29 {
                            MASK_29
                        } else if position == 30 {
                            MASK_30
                        } else {
                            MASK_31
                        }
                    }
                }
            } else {
                if position <= 47 {
                    if position <= 39 {
                        if position == 32 {
                            MASK_32
                        } else if position == 33 {
                            MASK_33
                        } else if position == 34 {
                            MASK_34
                        } else if position == 35 {
                            MASK_35
                        } else if position == 36 {
                            MASK_36
                        } else if position == 37 {
                            MASK_37
                        } else if position == 38 {
                            MASK_38
                        } else {
                            MASK_39
                        }
                    } else {
                        if position == 40 {
                            MASK_40
                        } else if position == 41 {
                            MASK_41
                        } else if position == 42 {
                            MASK_42
                        } else if position == 43 {
                            MASK_43
                        } else if position == 44 {
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
                        if position == 48 {
                            MASK_48
                        } else if position == 49 {
                            MASK_49
                        } else if position == 50 {
                            MASK_50
                        } else if position == 51 {
                            MASK_51
                        } else if position == 52 {
                            MASK_52
                        } else if position == 53 {
                            MASK_53
                        } else if position == 54 {
                            MASK_54
                        } else {
                            MASK_55
                        }
                    } else {
                        if position == 56 {
                            MASK_56
                        } else if position == 57 {
                            MASK_57
                        } else if position == 58 {
                            MASK_58
                        } else if position == 59 {
                            MASK_59
                        } else if position == 60 {
                            MASK_60
                        } else if position == 61 {
                            MASK_61
                        } else if position == 62 {
                            MASK_62
                        } else {
                            MASK_63
                        }
                    }
                }
            }
        } else {
            if position <= 94 {
                if position <= 79 {
                    if position <= 71 {
                        if position == 64 {
                            MASK_64
                        } else if position == 65 {
                            MASK_65
                        } else if position == 66 {
                            MASK_66
                        } else if position == 67 {
                            MASK_67
                        } else if position == 68 {
                            MASK_68
                        } else if position == 69 {
                            MASK_69
                        } else if position == 70 {
                            MASK_70
                        } else {
                            MASK_71
                        }
                    } else {
                        if position == 72 {
                            MASK_72
                        } else if position == 73 {
                            MASK_73
                        } else if position == 74 {
                            MASK_74
                        } else if position == 75 {
                            MASK_75
                        } else if position == 76 {
                            MASK_76
                        } else if position == 77 {
                            MASK_77
                        } else if position == 78 {
                            MASK_78
                        } else {
                            MASK_79
                        }
                    }
                } else {
                    if position <= 87 {
                        if position == 80 {
                            MASK_80
                        } else if position == 81 {
                            MASK_81
                        } else if position == 82 {
                            MASK_82
                        } else if position == 83 {
                            MASK_83
                        } else if position == 84 {
                            MASK_84
                        } else if position == 85 {
                            MASK_85
                        } else if position == 86 {
                            MASK_86
                        } else {
                            MASK_87
                        }
                    } else {
                        if position == 88 {
                            MASK_88
                        } else if position == 89 {
                            MASK_89
                        } else if position == 90 {
                            MASK_90
                        } else if position == 91 {
                            MASK_91
                        } else if position == 92 {
                            MASK_92
                        } else if position == 93 {
                            MASK_93
                        } else {
                            MASK_94
                        }
                    }
                }
            } else {
                if position <= 110 {
                    if position <= 102 {
                        if position == 95 {
                            MASK_95
                        } else if position == 96 {
                            MASK_96
                        } else if position == 97 {
                            MASK_97
                        } else if position == 98 {
                            MASK_98
                        } else if position == 99 {
                            MASK_99
                        } else if position == 100 {
                            MASK_100
                        } else if position == 101 {
                            MASK_101
                        } else {
                            MASK_102
                        }
                    } else {
                        if position == 103 {
                            MASK_103
                        } else if position == 104 {
                            MASK_104
                        } else if position == 105 {
                            MASK_105
                        } else if position == 106 {
                            MASK_106
                        } else if position == 107 {
                            MASK_107
                        } else if position == 108 {
                            MASK_108
                        } else if position == 109 {
                            MASK_109
                        } else {
                            MASK_110
                        }
                    }
                } else {
                    if position <= 118 {
                        if position == 111 {
                            MASK_111
                        } else if position == 112 {
                            MASK_112
                        } else if position == 113 {
                            MASK_113
                        } else if position == 114 {
                            MASK_114
                        } else if position == 115 {
                            MASK_115
                        } else if position == 116 {
                            MASK_116
                        } else if position == 117 {
                            MASK_117
                        } else {
                            MASK_118
                        }
                    } else {
                        if position == 119 {
                            MASK_119
                        } else if position == 120 {
                            MASK_120
                        } else if position == 121 {
                            MASK_121
                        } else if position == 122 {
                            MASK_122
                        } else if position == 123 {
                            MASK_123
                        } else if position == 124 {
                            MASK_124
                        } else if position == 125 {
                            MASK_125
                        } else {
                            MASK_126
                        }
                    }
                }
            }
        }
    } else {
        if position <= 189 {
            if position <= 157 {
                if position <= 141 {
                    if position <= 133 {
                        if position == 126 {
                            MASK_126
                        } else if position == 127 {
                            MASK_127
                        } else if position == 128 {
                            MASK_128
                        } else if position == 129 {
                            MASK_129
                        } else if position == 130 {
                            MASK_130
                        } else if position == 131 {
                            MASK_131
                        } else if position == 132 {
                            MASK_132
                        } else {
                            MASK_133
                        }
                    } else {
                        if position == 134 {
                            MASK_134
                        } else if position == 135 {
                            MASK_135
                        } else if position == 136 {
                            MASK_136
                        } else if position == 137 {
                            MASK_137
                        } else if position == 138 {
                            MASK_138
                        } else if position == 139 {
                            MASK_139
                        } else if position == 140 {
                            MASK_140
                        } else {
                            MASK_141
                        }
                    }
                } else {
                    if position <= 149 {
                        if position == 142 {
                            MASK_142
                        } else if position == 143 {
                            MASK_143
                        } else if position == 144 {
                            MASK_144
                        } else if position == 145 {
                            MASK_145
                        } else if position == 146 {
                            MASK_146
                        } else if position == 147 {
                            MASK_147
                        } else if position == 148 {
                            MASK_148
                        } else {
                            MASK_149
                        }
                    } else {
                        if position == 150 {
                            MASK_150
                        } else if position == 151 {
                            MASK_151
                        } else if position == 152 {
                            MASK_152
                        } else if position == 153 {
                            MASK_153
                        } else if position == 154 {
                            MASK_154
                        } else if position == 155 {
                            MASK_155
                        } else if position == 156 {
                            MASK_156
                        } else {
                            MASK_157
                        }
                    }
                }
            } else {
                if position <= 173 {
                    if position <= 165 {
                        if position == 158 {
                            MASK_158
                        } else if position == 159 {
                            MASK_159
                        } else if position == 160 {
                            MASK_160
                        } else if position == 161 {
                            MASK_161
                        } else if position == 162 {
                            MASK_162
                        } else if position == 163 {
                            MASK_163
                        } else if position == 164 {
                            MASK_164
                        } else {
                            MASK_165
                        }
                    } else {
                        if position == 166 {
                            MASK_166
                        } else if position == 167 {
                            MASK_167
                        } else if position == 168 {
                            MASK_168
                        } else if position == 169 {
                            MASK_169
                        } else if position == 170 {
                            MASK_170
                        } else if position == 171 {
                            MASK_171
                        } else if position == 172 {
                            MASK_172
                        } else {
                            MASK_173
                        }
                    }
                } else {
                    if position <= 181 {
                        if position == 174 {
                            MASK_174
                        } else if position == 175 {
                            MASK_175
                        } else if position == 176 {
                            MASK_176
                        } else if position == 177 {
                            MASK_177
                        } else if position == 178 {
                            MASK_178
                        } else if position == 179 {
                            MASK_179
                        } else if position == 180 {
                            MASK_180
                        } else {
                            MASK_181
                        }
                    } else {
                        if position == 182 {
                            MASK_182
                        } else if position == 183 {
                            MASK_183
                        } else if position == 184 {
                            MASK_184
                        } else if position == 185 {
                            MASK_185
                        } else if position == 186 {
                            MASK_186
                        } else if position == 187 {
                            MASK_187
                        } else if position == 188 {
                            MASK_188
                        } else {
                            MASK_189
                        }
                    }
                }
            }
        } else {
            if position <= 220 {
                if position <= 205 {
                    if position <= 197 {
                        if position == 190 {
                            MASK_190
                        } else if position == 191 {
                            MASK_191
                        } else if position == 192 {
                            MASK_192
                        } else if position == 193 {
                            MASK_193
                        } else if position == 194 {
                            MASK_194
                        } else if position == 195 {
                            MASK_195
                        } else if position == 196 {
                            MASK_196
                        } else {
                            MASK_197
                        }
                    } else {
                        if position == 198 {
                            MASK_198
                        } else if position == 199 {
                            MASK_199
                        } else if position == 200 {
                            MASK_200
                        } else if position == 201 {
                            MASK_201
                        } else if position == 202 {
                            MASK_202
                        } else if position == 203 {
                            MASK_203
                        } else if position == 204 {
                            MASK_204
                        } else {
                            MASK_205
                        }
                    }
                } else {
                    if position <= 213 {
                        if position == 206 {
                            MASK_206
                        } else if position == 207 {
                            MASK_207
                        } else if position == 208 {
                            MASK_208
                        } else if position == 209 {
                            MASK_209
                        } else if position == 210 {
                            MASK_210
                        } else if position == 211 {
                            MASK_211
                        } else if position == 212 {
                            MASK_212
                        } else {
                            MASK_213
                        }
                    } else {
                        if position == 214 {
                            MASK_214
                        } else if position == 215 {
                            MASK_215
                        } else if position == 216 {
                            MASK_216
                        } else if position == 217 {
                            MASK_217
                        } else if position == 218 {
                            MASK_218
                        } else if position == 219 {
                            MASK_219
                        } else {
                            MASK_220
                        }
                    }
                }
            } else {
                if position <= 235 {
                    if position <= 227 {
                        if position == 220 {
                            MASK_220
                        } else if position == 221 {
                            MASK_221
                        } else if position == 222 {
                            MASK_222
                        } else if position == 223 {
                            MASK_223
                        } else if position == 224 {
                            MASK_224
                        } else if position == 225 {
                            MASK_225
                        } else if position == 226 {
                            MASK_226
                        } else {
                            MASK_227
                        }
                    } else {
                        if position == 228 {
                            MASK_228
                        }   else if position == 229 {
                            MASK_229
                        } else if position == 230 {
                            MASK_230
                        } else if position == 231 {
                            MASK_231
                        } else if position == 232 {
                            MASK_232
                        } else if position == 233 {
                            MASK_233
                        } else if position == 234 {
                            MASK_234
                        } else {
                            MASK_235
                        }
                        
                    }
                } else {
                    if position <= 243 {
                        if position == 236 {
                            MASK_236
                        }   else if position == 237 {
                            MASK_237
                        }   else if position == 238 {
                            MASK_238
                        } else if position == 239 {
                            MASK_239
                        } else if position == 240 {
                            MASK_240
                        } else if position == 241 {
                            MASK_241
                        } else if position == 242 {
                            MASK_242
                        } else {
                            MASK_243
                        }
                    } else {
                        if position == 244 {
                            MASK_244   
                        }   else if position == 245 {
                            MASK_245
                        }   else if position == 246 {
                            MASK_246
                        }   else if position == 247 {
                            MASK_247
                        }   else if position == 248 {
                            MASK_248
                        }   else if position == 249 {
                            MASK_249
                        }   else if position == 250 {
                            MASK_250
                        }   else {
                            MASK_251
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

