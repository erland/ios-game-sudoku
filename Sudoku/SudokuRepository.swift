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
        "____462_59__53_1________39_34__1_6__5_______1__7_9__82_83________5_63__96_215____",
        "_52__3__8_________93_78_1_6__62__5___15___29___9__76__7_8_29_65_________6__5__42_",
        "7________3_6_714___95__38__6__854__3_________1__792__5__41__95___943_7_2________1",
        "___3__25925_4____1__97___6_1__8____5___647___6____1__7_9___41__5____2_84842__3___",
        "___4_2____9_____472451_____98_6_71__1___4___6__62_1_74_____948332_____9____8_6___",
        "___3___94____8_26_42__5_3___341___8___1___9___6___351___2_7__56_17_6____85___1___",
        "5__2___3_____5___92____7_4__97_4__6243__7__1561__2_87__2_4____37___3_____8___9__6",
        "1__5______46_92___38___65_9__5_2__1__6__8__5__1__6_8__9_76___81___94_27______1__5",
        "________51___987__2_8__561___41__538_________897__32___657__1_2__158___64________"
    ]
    let medium : [String] = [
        "26__1____1_74___5____8_6_7__9__8_____827_319_____4__8__1_6_8____5___43_8____5__64",
        "5__86_____64_____5___3__176___4_23__4_8_3_7_9__39_8___147__6___9_____46_____47__2",
        "_4___6______9_____3_2__86_1__53_7_86_37_9_15_16_8_42__6_41__7_2_____5______7___6_",
        "26_89_7_59__________52_1_8_5_________149_867_________4_8_7_21__________74_7_65_28",
        "_4___9_3_6_____8__5_2643__1____8__47__8_6_3__72__1____3__2961_5__5_____9_9_5___2_",
        "_7___6851___25__766_8_____3______6_2___1_9___3_4______2_____1_894__87___5863___4_",
        "___2_3___12__5_87__5_8___2_8___65__35_______89__38___5_4___7_1__71_9__36___6_1___",
        "_918_4___7__2____3_36___21______5____786_215____7______24___98_5____8__6___1_643_",
        "____2__9_____8____1_3__72_6__4__5_197_68_95_458_2__6__9_86__3_7____7_____2__9____",
        "6______977_8_2______3__42___8_36__5_9__4_7__3_7__89_2___92__5______7_4_645______2",
        "_7___2__4___7_4265__86_9___534___6______2______9___517___9_81__9172_5___8__4___2_",
        "_67_5184____47_5__1____8__3____46______9_7______21____8__1____5__4_92____9183_76_"
    ]
    let hard : [String] = [
        "1____93_4_____3__6_83___25__9_81_____4_396_2_____52_9__39___67_8__2_____7_49____2",
        "___42__6__58__9_72_____81_5__5_____7_3_9_6_8_8_____2__5_91_____72_6__94__6__92___",
        "2_4_____8159_2___7__8_3_4_____9____5_1_5_7_4_9____1_____3_7_5__5___1_8936_____7_4",
        "___7____4_231__9___67_3__5__31_57______249______36_59__5__1_38___8__362_3____8___",
        "6_5_______12____6_7__6__4_1_4_9_82____63_17____15_2_8_1_4__6__2_2____63_______1_5",
        "28___6____1_8___6_____21_575__9____672_____396____3__543_61_____7___9_4____4___71",
        "5_43___29___2__4____35__6_8_32_4_9_____________6_9_84_3_9__57____8__1___41___82_6",
        "_496__8__15___8__32_83___1_6___7_____1_____7_____5___1_6___41_27__5___96__2__135_",
        "8__6___13_____4__52___3_4____849_3___7_513_6___3_269____2_6___41__7_____36___1__8",
        "942__87_____35______5__46_8____4_912_________281_7____7_42__5______95_____84__261",
        "_7_____64____4_281___6_2_7___1___9__75_4_9_16__8___4___1_8_6___496_5____82_____9_",
        "_____271__7___5__4_4___8_9285__2_9_3_________3_7_9__5868_2___4_4__5___2__296_____"
    ]
    let veryHard : [String] = [
        "___342_5____568_13___9__4___4_7____8_7__3__4_5____9_3___2__5___15_694____6_273___",
        "_8__15___6___92__83__4___6__93__6__4_5_____2_7__5__91__6___4__22__86___5___92__8_",
        "_76__34_219_42____4___76____1______3___712___6______4____36___5____94_313_12__69_",
        "_52_46_3__1__9____7____3_____1__5_289_5___6_162_9__5_____6____4____3__1__9_41_35_",
        "___3_516____9_6___6_42____8148___2_3_________3_5___6474____23_5___6_4____715_8___",
        "_75_6_4__________66__3___1__64_5_1_7__36_95__5_2_7_36__5___4__23__________1_3_97_",
        "____8________4__521_9__643__3__6_2__7_21385_6__5_9__8__264__8_198__1________2____",
        "__3_42_517_89________3_1___3__1___9__57___32__8___3__5___5_4________96_784_63_5__",
        "_____196___9_4_1_8___6____7__2__7_5974_____8289_2__7__9____3___2_7_1_6___348_____",
        "___1____22_7_8__91_3__2_4_____4___859__2_3__445___8_____6_7__1_79__6_5_38____2___",
        "8___46_393__5__7___6___34_____3___289_______162___1_____36___9___6__9__729_41___5",
        "8_92_1_7__6___4_91____9___2_7_6__91___________23__7_4_2___7____41_3___5__3_1_54_6"
    ]

    func validateBoards() {
        var success = true
        for difficulty in [Difficulty.Easy, Difficulty.Medium, Difficulty.Hard, Difficulty.VeryHard] {
            var level = 1
            var board = getBoard(difficulty: difficulty, level: level)
            while board != nil {
                let solver = BruteForceSolverBoard.init(boardString: board!)
                if !solver.solve() {
                    success = false
                    print("Failed to solve \(difficulty) \(level)")
                    solver.printBoard()
                }else {
                    print("Successfully validated \(difficulty) \(level)")
                    //print("\(difficulty) \(level) estimated as: \(calculateDifficulty(boardNumbers: board!))")
                }
                level = level + 1
                board = getBoard(difficulty: difficulty, level: level)
            }
        }
        if success {
            print("Successfully validated all boards")
        }
    }
    func getBoard(difficulty: Difficulty, level: Int) -> String? {
        var levelNo = level
        if level < 1 {
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
                                                                                                  SwordFish(),
                                                                                                  SimpleColouring()]) {
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
                                                            SwordFish(),
                                                            SimpleColouring()],
                                            maxNumbers: 28, timeoutSeconds: 120)
    }
    

    func getGeneratedBoard(difficulty: Difficulty) -> String? {
        let generator = BoardGenerator()
        switch difficulty {
        case .Easy:
            return generator.generateWithLimits(maxTechniques: [SingleCandidate(),
                                                             SinglePosition()],
                                                maxNumbers: 28, timeoutSeconds: 120)
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
                                                maxNumbers: 28, timeoutSeconds: 120)
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
                                                             SwordFish(),
                                                             SimpleColouring()],
                                                maxNumbers: 28, timeoutSeconds: 120)
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
