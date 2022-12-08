use rucksack::Rucksack;

mod rucksack {
    pub struct Rucksack<'a> {
        parts: [&'a [u8]; 2], /* Every rucksack has two compartments. */
    }

    impl<'a> Rucksack<'a> {
        pub fn new(buf: &'a [u8]) -> Self {
            let count = buf.len() / 2;
            assert_eq!(buf.len(), count * 2);
            Self {
                parts: [&buf[0..count], &buf[count..]],
            }
        }

        pub fn parts(&self) -> &[&'a [u8]; 2] {
            &self.parts
        }
    }
}

fn rucksacks(buf: &[u8]) -> Vec<Rucksack> {
    let mut sacks = vec![];
    let mut i = 0;
    let mut iter = buf.iter();
    while i < buf.len() {
        let lf = i + iter
            .position(|byte| *byte == '\n' as u8)
            .expect("missed LF");
        sacks.push(Rucksack::new(&buf[i..lf]));
        i = lf + 1;
    }
    sacks
}

fn priority(type_: u8) -> u8 {
    if 'a' as u8 <= type_ && type_ <= 'z' as u8 {
        return type_ - 96;
    }
    if 'A' as u8 <= type_ && type_ <= 'Z' as u8 {
        return type_ - 38;
    }
    panic!("type out of range: {}", type_);
}

fn badge(sacks: &[Rucksack]) -> u8 {
    let mut types = [0_u8; 128];
    for sack in sacks {
        let mut sack_set = [0_u8; 128];
        for part in sack.parts() {
            for item in *part {
                let item = *item;
                sack_set[item as usize] += 1;
                if sack_set[item as usize] == 1 {
                    types[item as usize] += 1;
                    if types[item as usize] == sacks.len() as u8 {
                        return item;
                    }
                }
            }
        }
    }
    panic!("no badge");
}

fn first_misclassified_type(sack: &Rucksack) -> u8 {
    // TODO What!  I got lucky?!  I didn't implement the rule about types being case-insensitive...
    let mut types = [0_u8; 128];
    for item in sack.parts()[0] {
        types[*item as usize] += 1;
    }
    for item in sack.parts()[1] {
        if types[*item as usize] > 0 {
            return *item;
        }
    }
    panic!("no misclassified");
}

fn main() {
    let mut args = std::env::args();
    args.next();
    let buf = std::fs::read_to_string(args.next().expect("usage: rucksack INPUTFILE")).unwrap();
    let sacks = rucksacks(buf.as_bytes());
    let mut problem1: u64 = 0;
    let mut problem2: u64 = 0;
    for i in 0..sacks.len() {
        problem1 += priority(first_misclassified_type(&sacks[i])) as u64;
        if (i + 1) % 3 == 0 {
            /* elves come in threes */
            problem2 += priority(badge(&sacks[i - 2..i + 1])) as u64;
        }
    }
    println!("{} {}\n", problem1, problem2);
}
