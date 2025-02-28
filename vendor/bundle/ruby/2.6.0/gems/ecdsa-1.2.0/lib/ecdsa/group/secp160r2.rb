# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp160r2 = new(
      name: 'secp160r2',
      p: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFAC73,
      a: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFAC70,
      b: 0xB4E134D3_FB59EB8B_AB572749_04664D5A_F50388BA,
      g: [0x52DCB034_293A117E_1F4FF11B_30F7199D_3144CE6D,
          0xFEAFFEF2_E331F296_E071FA0D_F9982CFE_A7D43F2E],
      n: 0x01_00000000_00000000_0000351E_E786A818_F3A1A16B,
      h: 1,
    )
  end
end
