# Source: http://www.secg.org/collateral/sec2_final.pdf

module ECDSA
  class Group
    Secp224k1 = new(
      name: 'secp224k1',
      p: 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFE56D,
      a: 0,
      b: 5,
      g: [0xA1455B33_4DF099DF_30FC28A1_69A467E9_E47075A9_0F7E650E_B6B7A45C,
          0x7E089FED_7FBA3442_82CAFBD6_F7E319F7_C0B0BD59_E2CA4BDB_556D61A5],
      n: 0x01_00000000_00000000_00000000_0001DCE8_D2EC6184_CAF0A971_769FB1F7,
      h: 1,
    )
  end
end
