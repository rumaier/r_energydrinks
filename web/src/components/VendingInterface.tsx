import { Image, Paper, Transition, UnstyledButton } from "@mantine/core";
import { useState, type FC } from "react";
import { useKeybind } from "../hooks/useKeybind";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import BlueImage from "../assets/images/junk_blue.webp"
import GreenImage from "../assets/images/junk_green.webp"
import OrangeImage from "../assets/images/junk_orange.webp"
import PurpleImage from "../assets/images/junk_purple.webp"
import RedImage from "../assets/images/junk_red.webp"
import classes from "./VendingInterface.module.css";

type DrinkColor = 'blue' | 'green' | 'orange' | 'purple' | 'red';

interface DrinkOption {
  color: DrinkColor;
  image?: string;
}

const DRINKS: DrinkOption[] = [
  { color: 'blue', image: BlueImage },
  { color: 'green', image: GreenImage },
  { color: 'orange', image: OrangeImage },
  { color: 'purple', image: PurpleImage },
  { color: 'red', image: RedImage },
];

const VendingInterface: FC = () => {
  const [visible, setVisible] = useState<boolean>(false);

  useNuiEvent('openVendingInterface', () => {
    setVisible(true);
  });

  const closeVendingInterface = () => {
    fetchNui('setNuiFocus', false);
    setVisible(false);
  };

  useKeybind('Escape', () => {
    if (!visible) return;
    closeVendingInterface();
  });

  const handleSelect = (color: DrinkColor) => {
    fetchNui('purchaseDrink', { color });
    closeVendingInterface();
  };

  return (
    <Transition mounted={visible} transition='pop' duration={200}>
      {(styles) => (
        <Paper
          pos='absolute'
          top='15%'
          left='55%'
          radius='sm'
          bg='dark.8'
          className={classes.panel}
          style={{ ...styles, userSelect: 'none' }}
        >
          <div className={classes.stack}>
            {DRINKS.map((drink) => (
              <UnstyledButton
                key={drink.color}
                className={classes.button}
                onClick={() => handleSelect(drink.color)}
              >
                {drink.image ? (
                  <Image src={drink.image} className={classes.image} fit='cover' />
                ) : null}
              </UnstyledButton>
            ))}
          </div>
        </Paper>
      )}
    </Transition>
  );
};

export default VendingInterface;
