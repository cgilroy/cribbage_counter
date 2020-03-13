function getPointsForHand(hand, starter){
         var permutations = permute(hand.concat([starter]));
         var points = 0;
        //  return permutations
         for (var i=0, ii=permutations.length; i<ii; i++){
             var description = [];
             var permPoints = 0;
             var cards = permutations[i];
             cards.sort(Card.cmp);
             var j = cards.length;
             var sum = 0;
             while (j--){
                 sum += cards[j].getValue();
             }
             if (sum == 15){
                 description.push("15 for 2");
                 permPoints += 2;
             }
             if (cards.length == 1){ // nobs
                 description.push("nobs for 1");
                 var c = cards[0];
                 if (c !== starter && c.number === JACK && c.suit === starter.suit){
                     permPoints += 1;
                 }
             }
             if (cards.length == 2 && cards[0].number == cards[1].number){
                 description.push("two of a kind for 2");
                 permPoints += 2; // 2 of a kind.
             }
             if (cards.length >= 3){ // straights
                 var last = cards[cards.length-1];
                 j = cards.length-1;
                 var isStraight = true;
                 while (j--){
                     if (last.number !== cards[j].number+1){
                         isStraight = false;
                         break;
                     }
                     last = cards[j];
                 }
                 if (isStraight){
                     description.push("straight for "+cards.length);
                     permPoints += cards.length;
                 }
             }
             if (cards.length >= 4){ //flushes
                 var suit = cards[0].suit;
                 j = cards.length;
                 var isFlush = true;
                 while (j--){
                     if (j.suit !== suit){
                         isFlush = false;
                         break;
                     }
                 }
                 if (isFlush){
                     description.push("flush for "+cards.length);
                     permPoints += cards.length;
                 }
             }
             if (permPoints){
                 log(cards.join(" "), "-->", description.join(", "));
             }
             points += permPoints;
         }
         return points;
     }

     /**
      * Get permuations of stuff.
      */
     function permute(items){
         var perms = [];
         for (var i=0, ii=items.length; i<ii; i++){
             var base = [items[i]];
             perms.push(base);
             var subitems = permute(items.slice(i+1));
             var j = subitems.length;
             while (j--){
                 perms.push(base.concat(subitems[j]));
             }
             //for (var j=0, jj=subitems.length; j<jj; j++){
             //    perms.push(base.concat(subitems[j]));
             //}
         }
         return perms;
     }

     let x = getPointsForHand([2,3,4,5],6)
     console.log(x)