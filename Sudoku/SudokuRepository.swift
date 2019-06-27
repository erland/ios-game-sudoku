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
    
    func getBoard(difficulty: Difficulty, level: Int) -> String? {
        var levelNo = level
        if level < 1 || level > 4 {
            return nil
        }
        levelNo = level - 1

        switch difficulty {
        case .Easy:
            if levelNo<easy.count {
                return easy[levelNo]
            }
        case .Medium:
            if levelNo<medium.count {
                return medium[levelNo]
            }
        case .Hard:
            if levelNo<hard.count {
                return hard[levelNo]
            }
        case .VeryHard:
            if levelNo<veryHard.count {
                return veryHard[levelNo]
            }
        }
        return nil
    }
    
    func calculateDifficulty(boardNumbers: String) -> Difficulty {
        if TechniqueSolverBoard(boardString: boardNumbers, debug: false).solve(techniques: [SingleCandidate(),
                                                                                            SinglePosition()]) {
            return Difficulty.Easy
        }else if TechniqueSolverBoard(boardString: boardNumbers, debug: false).solve(techniques: [SingleCandidate(),
                                                                                                  SinglePosition(),
                                                                                                  CandidateLines(),
                                                                                                  MultipleLines()]) {
            return Difficulty.Medium
        }else if TechniqueSolverBoard(boardString: boardNumbers, debug: false).solve(techniques: [SingleCandidate(),
                                                                                                  SinglePosition(),
                                                                                                  CandidateLines(),
                                                                                                  MultipleLines(),
                                                                                                  NakedPairs(),
                                                                                                  NakedTriples(),
                                                                                                  HiddenPairs(),
                                                                                                  HiddenTriples()]) {
            return Difficulty.Hard
        }else if TechniqueSolverBoard(boardString: boardNumbers, debug: false).solve(techniques: [SingleCandidate(),
                                                                                                  SinglePosition(),
                                                                                                  CandidateLines(),
                                                                                                  MultipleLines(),
                                                                                                  NakedPairs(),
                                                                                                  NakedTriples(),
                                                                                                  NakedQuads(),
                                                                                                  HiddenPairs(),
                                                                                                  HiddenTriples(),
                                                                                                  HiddenQuads(),
                                                                                                  XWing(),
                                                                                                  YWing(),
                                                                                                  SwordFish()]) {
            return Difficulty.VeryHard
        }else {
            print("Unable to solve board with implemented techniques")
            return Difficulty.VeryHard
        }
    }
    
    func getGeneratedBoard() -> String? {
        let generator = BoardGenerator()
        return generator.generateWithLimits(maxTechniques: [SingleCandidate(),
                                                            SinglePosition(),
                                                            CandidateLines(),
                                                            MultipleLines(),
                                                            NakedPairs(),
                                                            NakedTriples(),
                                                            HiddenPairs(),
                                                            HiddenTriples(),
                                                            XWing(),
                                                            YWing(),
                                                            SwordFish()],
                                            maxNumbers: 28, timeoutSeconds: 60)
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
                                                             YWing(),
                                                             SwordFish()],
                                                maxNumbers: 25, timeoutSeconds: 120)
        }
    }
    
    //board = Board(name: "Player", boardNumbers: "2____1_49__8____61___7_6528654__9_1__924__6___31___4_2_2_387_5_347195286_8_6_41_7")
    //board = Board(name: "Player", boardNumbers: "86793421554312679819258734692641385778465912331527896423174568965839147247986253_")
    //let repository = SudokuRepository()
    //var boardNumbers = repository.getBoard(difficulty: .VeryHard, level: 1)
    //var boardNumbers = "2____1_49__8____61___7_6528654__9_1__924__6___31___4_2_2_387_5_347195286_8_6_41_7"
    //var boardNumbers = "86793421554312679819258734692641385778465912331527896423174568965839147247986253_"
    // naked pairs
    //var boardNumbers = "597_4__3_348____6_612_9__8475____49_8_9____7_4__6___5_17__2_64_96__83_2_28_____1_"
    // naked triples
    //var boardNumbers = "__3_____1_9__35268__________7____18613_86_725286___943_41_8_3___5_2_6_1______3_7_"
    // naked quad
    //var boardNumbers = "_9________28___9_6___7_9__2____26__43___1_________7__3_1_____59__4_8__31_82__1__7"
    // hidden pair
    //var boardNumbers = "_________9_46_7____768_41__3_97_1_8_7_8___3_1_513_87_2__75_261___54_32_8_________"
    //var boardNumbers = "72_4_8_3__8_____474_1_768_281_739______851______264_8_2_968_41334______8168943275"
    // hidden triples
    //var boardNumbers = "28____473534827196_71_34_8_3__5___4____34__6_46_79_31__9_2_3654__3__9821____8_937"
    //var boardNumbers = "5__62__37__489________5____93________2____6_57_______3_____9_________7__68_57___2"
    // hidden quad
    //var boardNumbers = "816573294392______4572_9__6941___5687854961236238___4_279_____1138____7_564____82"
    //var boardNumbers = "_3_____1___8_9____4__6_8______57694____98352____124___276__519____7_9____95___47_"
    // XWing
    //var boardNumbers = "857912__629134675834678519212456_9_376_____259_5_2_6_14126__5_767_25__1_5___7_26_"
    // YWing
    //var boardNumbers = "9__24_____5_69_231_2__5__9__9_7__32___29356_7_7___29___69_2__7351__79_622_7_86__9"

    
    // Swordfish
    //var boardNumbers = "195367248_78_5_3693_6_98157__378_59_7_9__5__65849_671_8325496719_7_13_25_51_729__"
    //var boardNumbers = "52941_7_3__6__3__2__32______523___76637_5_2__19_62753_3___6942_2__83_6__96_7423_5"
    //var boardNumbers = "_2__43_69__38962__96__25_3_89_56__136___3_____3__81_263___1__7___96743_227_358_9_"
    
    // Simple colouring
    //var boardNumbers = "123___587__5817239987___164_51__847339_75_6187_81__925_76___89153__8174681__7_352"
    //var boardNumbers = "214__6_____79_2__4___4_7_____187__32__269_____48_21__642_7_9861__9168___18624___9"
    //var boardNumbers = "659___13___1_3_6252_3165_49_2__9631_36_7__59_91_3_4_6279_6__2535_6___9811_2___476"

}
