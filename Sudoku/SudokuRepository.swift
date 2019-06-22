//
//  SudokuRepository.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-16.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

class SudokuRepository {
    enum Difficulty {
        case Easy
        case Medium
        case Hard
        case VeryHard
    }
    let easy : [String] = [
        "__63_81_2____1__3_2__9___589____7_41____2____14_5____689___1__5_6__3____3_56_92__",
        "6_8______9_31_584______87______1_2_55__982__47_9_3______23______672_94_3______1_7",
        "4_97_____32_1___74__82__5_____4_73___1_____6___39_8_____6__19__84___5_26_____41_8",
        "____462_59__53_1________39_34__1_6__5_______1__7_9__82_83________5_63__96_215____"
    ]
    let medium : [String] = [
        "26__1____1_74___5____8_6_7__9__8_____827_319_____4__8__1_6_8____5___43_8____5__64",
        "5__86_____64_____5___3__176___4_23__4_8_3_7_9__39_8___147__6___9_____46_____47__2",
        "_4___6______9_____3_2__86_1__53_7_86_37_9_15_16_8_42__6_41__7_2_____5______7___6_",
        "26_89_7_59__________52_1_8_5_________149_867_________4_8_7_21__________74_7_65_28"
    ]
    let hard : [String] = [
        "1____93_4_____3__6_83___25__9_81_____4_396_2_____52_9__39___67_8__2_____7_49____2",
        "___42__6__58__9_72_____81_5__5_____7_3_9_6_8_8_____2__5_91_____72_6__94__6__92___",
        "2_4_____8159_2___7__8_3_4_____9____5_1_5_7_4_9____1_____3_7_5__5___1_8936_____7_4",
        "___7____4_231__9___67_3__5__31_57______249______36_59__5__1_38___8__362_3____8___"
    ]
    let veryHard : [String] = [
        "___342_5____568_13___9__4___4_7____8_7__3__4_5____9_3___2__5___15_694____6_273___",
        "_8__15___6___92__83__4___6__93__6__4_5_____2_7__5__91__6___4__22__86___5___92__8_",
        "_76__34_219_42____4___76____1______3___712___6______4____36___5____94_313_12__69_",
        "_52_46_3__1__9____7____3_____1__5_289_5___6_162_9__5_____6____4____3__1__9_41_35_"
    ]
    
    func getBoard(difficulty: Difficulty, level: Int) -> String {
        var levelNo = level
        if level < 1 && level > 4 {
            levelNo = Int.random(in: 1 ... 4)
        }
        levelNo = level - 1

        switch difficulty {
        case .Easy:
            return easy[levelNo]
        case .Medium:
            return medium[levelNo]
        case .Hard:
            return hard[levelNo]
        case .VeryHard:
            return veryHard[levelNo]
        }
    }
    
    func getGeneratedBoard(difficulty: Difficulty) -> String? {
        let generator = BoardGenerator()
        switch difficulty {
        case .Easy:
            return generator.generateWithLimits(maxTechniques: [SingleCandidate(),
                                                             SinglePosition()],
                                                maxNumbers: 28, timeoutSeconds: 30)
        case .Medium:
            return generator.generateWithLimits(tooEasyTechniques: [SingleCandidate(),
                                                                      SinglePosition()],
                                                maxTechniques: [SingleCandidate(),
                                                             SinglePosition(),
                                                             CandidateLines(),
                                                             MultipleLines()],
                                                maxNumbers: 28, timeoutSeconds: 120)
        case .Hard:
            return generator.generateWithLimits(tooEasyTechniques: [SingleCandidate(),
                                                                    SinglePosition(),
                                                                    CandidateLines(),
                                                                    MultipleLines()],
                                                maxTechniques: [SingleCandidate(),
                                                             SinglePosition(),
                                                             CandidateLines(),
                                                             MultipleLines(),
                                                             NakedPairs(),
                                                             NakedTriples(),
                                                             HiddenPairs(),
                                                             HiddenTriples()],
                                                maxNumbers: 25, timeoutSeconds: 120)
        case .VeryHard:
            return generator.generateWithLimits(tooEasyTechniques: [SingleCandidate(),
                                                                    SinglePosition(),
                                                                    CandidateLines(),
                                                                    MultipleLines(),
                                                                    NakedPairs(),
                                                                    NakedTriples(),
                                                                    HiddenPairs(),
                                                                    HiddenTriples()],
                                                maxTechniques: [SingleCandidate(),
                                                             SinglePosition(),
                                                             CandidateLines(),
                                                             MultipleLines(),
                                                             NakedPairs(),
                                                             NakedTriples(),
                                                             HiddenPairs(),
                                                             HiddenTriples(),
                                                             XWing(),
                                                             YWing()],
                                                maxNumbers: 25, timeoutSeconds: 120)
        }
    }
}
