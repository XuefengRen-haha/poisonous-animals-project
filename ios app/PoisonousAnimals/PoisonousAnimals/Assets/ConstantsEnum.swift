//
//  Constant.swift
//  SpiderRecognizer
//
//  Created by DonghanYang on 29/5/19.
//  Copyright © 2019 DonghanYang. All rights reserved.
//

import Foundation
import UIKit

/**
 An enum stores all static information of this project
 - information of image classifier model and object detector model
 - poisonousness level of spiders
 - color mapping of poisonousness level
 - introduction of 9 kinds of spiders
 */
public enum ConstantsEnum {
    
    /** information of image classifier model */
    static let imageClassifier = MobileNetV2().model
    
    /** information of object detector model */
    static let objectDetector = MobileNetV2_SSDLite().model
    
    /** poisonousness level of spiders */
    static let spiderMapping = ["Long Legs Spider": "Safe",
                                "Australian Bee": "Safe",
                                "Carpet Python": "Safe",
                                "Blue Tongued Lizard": "Low Risk",
                                "Tarantula Spider": "Low Risk",
                                "Lowland Copperhead": "Low Risk",
                                "Red Bellied Black Snake": "Dangerous",
                                "Redback Spider": "Dangerous",
                                "European Wasp": "Dangerous"]
    
    /** color mapping of poisonousness level */
    static let colorMapping = ["Safe": UIColor.green,
                               "Dangerous": UIColor.red,
                               "Low Risk": UIColor.orange]
    
    /** introduction of 9 kinds of spiders */
    static let spiderIntro = [
                              "Long Legs Spider": "Long Legs spiders are thin and delicate arachnids. The body (resembling the shape of a peanut) is approximately 2–10 mm (0.08–0.39 inch) in length, and the legs may be up to 50 mm (1.97 inches) long. Pholcus and Smeringopus have cylindrical abdomens and eyes arranged in two lateral groups of three and two smaller median contiguous eyes. Arrangements of eight and six eyes both occur in this family. Spermophora has a small globose abdomen and its eyes are arranged in two groups of three without median eyes.",
                              "Australian Bee": "Australia Bees have over 1,700 species of native bee. Wasps and flies do not do this, although they may be seen eating pollen, so identification is not always easy.Eleven of the species, the social native bees, are in two genera, Tetragonula and Austroplebeia, and have no sting.  Of the remainder, which live solitary lives, none are aggressive, and most cannot actually use their sting on humans because they are too small to do so. Larger examples of Australian native bee are capable of stinging if handled or squashed. The stings of most Australian native species of bee will cause relatively minor discomfort to most people -- not as painful as those of a bull ant or paper wasp and last only a few minutes. However, they may sting more than once, and can cause an allergic reaction—increasing effect associated with repeated exposure to the antigen.",
                              "Carpet Python": "Carpet Python is a large species of python in the genus, reaching between 2 and 4 m (6.6 and 13.1 ft) in length and weighing up to 15 kg (33 lb). M. s. mcdowelli is the largest subspecies, regularly attaining lengths of 2.7–3 m (8.9–9.8 ft). M.s.variegata is the smallest subspecies, typically 120–180 cm (3.9–5.9 ft) in length. The average adult length is roughly 2 m (6.6 ft). However, one 3-year-old captive male M.s.mcdowelli, measured in Ireland, was found to exceed 396 cm (12.99 ft). Males are typically smaller than females; in some regions, females are up to four times heavier.",
                              "Blue Tongued Lizard": "Blue Tongued lizard (Tiliqua scincoides scincoides) is a subspecies of large skink which is common throughout eastern Australia, often found in bushland and suburban areas where conditions are suitable. The lizard is known as blue-tongue because its tongue can range from bright to dark blue, and it has a habit of displaying it prominently and hissing loudly when disturbed. The eastern blue-tongued skink is a stout and slow lizard with brown to grey scales and a barred pattern across the body and tail. The underside is usually pale. Blue-tongued lizards are popular as pets and can live up to 30 years in captivity.",
                              "Tarantula Spider": "Tarantulas comprise a group of large and often ″hairy″ spiders of the family Theraphosidae (technically, spiders possess setae, not true hairs). Currently, about 1,000 species have been identified. The term tarantula is usually used to describe members of the family Theraphosidae. Some of the more common species have become popular in the exotic pet trade. Many New World species kept as pets have urticating hairs that can cause irritation to the skin, and in extreme cases, cause damage to the eyes.",
                              "Lowland Copperhead": "The lowland copperhead or lowlands copperhead (Austrelaps superbus) is a venomous snake species in the family Elapidae, found in southeastern Australia and Tasmania. It is commonly referred to as the copperhead, but is not closely related to the American copperhead, Agkistrodon contortrix. If provoked, the lowland copperhead is a dangerous snake with neurotoxic venom, which can kill an adult human if correct first aid is not applied promptly.The lowland copperhead is generally 1-1.5m(3–5 feet) long. Their colour varies a great deal, from a coppery mid-brown to yellowish, reddish, grey or black.",
                              "Red Bellied Black Snake": "The red-bellied black snake has a glossy black top body with a light-grey snout and brown mouth, and a completely black tail. It lacks a well-defined neck; its head merges seamlessly into the body. Its flanks are bright red or orange, fading to pink or dull red on the belly. All these scales have black margins. Snakes from northern populations tend to have lighter, more cream or pink bellies. The red-bellied black snake is on average around 1.25 m (4 ft 1 in) long, the largest individual recorded at 2.55 m (8 ft 4 in). Males are generally slightly larger than females.",
                              "Redback Spider": "The redback spider (Latrodectus hasselti), also known as the Australian black widow, is a species of highly venomous spider believed to originate in South Australia or adjacent Western Australian deserts, but now found throughout Australia, Southeast Asia and New Zealand, with colonies elsewhere outside Australia. It is a member of the cosmopolitan genus Latrodectus, the widow spiders. The adult female is easily recognised by her spherical black body with a prominent red stripe on the upper side of her abdomen and an hourglass-shaped red/orange streak on the underside.",
                              "European Wasp": "European wasp is a species of wasp found in much of the Northern Hemisphere, native to Europe, Northern Africa, and temperate Asia. It has spread and become well-established in many other places, including North America, South America (Argentina and Chile), Australia, and New Zealand. German wasps are part of the family Vespidae and are sometimes mistakenly referred to as paper wasps because they build grey paper nests, although strictly speaking, paper wasps are part of the subfamily Polistinae. In North America, they are also known as yellowjackets."]
    
    static let cnn_transfer =
         ["Daddy Long Legs Spider":"Long Legs Spider",
          "St Andrews Cross Spider":"Red Bellied Black Snake",
          "Garden Orb Weaver Spider":"Carpet Python",
          "Huntsman Spider":"Blue Tongued Lizard",
          "Tarantula Spider":"Tarantula Spider",
          "White-Tailed Spider":"Lowland Copperhead",
          "Red-Headed Mouse Spider":"Australian Bee",
          "Redback Spider":"Redback Spider",
          "Funnel-Web Spider":"European Wasp"]
    
    static let ssd_transfer =
         ["Daddy Long Legs Spider":"Long Legs Spider",
          "St Andrews Cross Spider":"Australian Bee",
          "Garden Orb Weaver Spider":"Carpet Python",
          "Huntsman Spider":"Blue Tongued Lizard",
          "Tarantula Spider":"Tarantula Spider",
          "White-Tailed Spider":"Lowland Copperhead",
          "Red Headed Mouse Spider":"Red Bellied Black Snake",
          "Redback Spider":"Redback Spider",
          "Funnel Web Spider":"European Wasp"]
    
}
