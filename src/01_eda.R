

library(ProjectTemplate)
load.project()


library(plotly)
library(imputeTS)
library(mi)

# Union de df ----
df_cpj %>% head()
df_cpj_confirmed %>% head

df_cpj_union <- df_cpj %>% 
  dplyr::select(name, sex, `country killed`, 
                motive,
                date_registered, month_year, year) %>% 
  filter(motive == "Unconfirmed") %>% 
  bind_rows(df_cpj_confirmed %>% 
              dplyr::select(name, sex = gender, `country killed` = country, 
                            motive, 
                            date_registered, month_year, year) ) 

df_cpj_union
cache('df_cpj_union')


# Variables ----

# summary
tab <- df_cpj_union %>% 
  filter(year < 2018) %>% 
  group_by(`country killed`, year, motive) %>% 
  summarise(value = n()) %>% 
  ungroup() %>% 
  complete(nesting(motive, year), `country killed`, fill = list(value = 0)) %>% 
  filter(`country killed` == "Bahrain") %>%
  group_by(year, motive) %>% 
  summarise(value = sum(value)) %>% 
  ungroup() %>% 
  spread(motive, value, fill = 0) %>% 
  mutate(UnconfirmedNA = ifelse(year > 2016, NA, Unconfirmed)) %>% 
  arrange(desc(year)) %>% 
  mutate(UnconfirmedIMP = round(na.ma(UnconfirmedNA))) %>% 
  dplyr::select(year, Confirmed, Unconfirmed = UnconfirmedIMP) %>% 
  gather(motive, value,  -year) %>% 
  mutate(motive = ifelse(year > 2016 & motive == "Unconfirmed", 
                         "Unconfirmed Imp", 
                         motive))
tab


# # MI ----
# df_tab <- data.frame(tab) %>% 
#   dplyr::select(-Unconfirmed)
# mdf <- missing_data.frame(df_tab) # warnings about missingness patterns
# show(mdf)
# imputations <- mi(mdf)
# dfs <- complete(imputations)
# dfs

gg <- tab %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = factor(motive) ))  +  
  geom_bar(stat = "identity") + 
  scale_x_continuous(breaks = seq(1991, 2019, by = 3),
                     limits = c(1992, 2018)) +
  guides(fill = guide_legend("Motive")) +
  ylab("Journalists killed") + 
  xlab("Date") 
gg
# ggplotly(gg)


gg <- tab %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = factor(motive, c("Unconfirmed", "Confirmed") )))  +  
  geom_bar(stat = "identity", position = "fill") + 
  geom_hline(yintercept = .5) + 
  scale_x_continuous(breaks = seq(1991, 2019, by = 3)) +
  guides(fill = guide_legend("Motive")) +
  ylab("Journalists killed") + 
  xlab("Date")
gg
# ggplotly(gg)



# mapa del mundo ----
world <- map_data(map = "world")
world %>% head
ggmap_freq <- function(sub){
  tt.gg <- world %>% 
    as_tibble() %>% 
    mutate(region = tolower(region)) %>% 
    left_join( sub, 
               by = c("region" = "country_killed"))
  ggplot(tt.gg, aes(x = long, y = lat, 
                    group = group, fill = freq))+ 
    geom_polygon() + 
    theme_bw() + 
    coord_fixed() + 
    theme(rect = element_blank(), 
          line = element_blank(),
          axis.text = element_blank(), 
          axis.ticks = element_blank(),
          plot.title = element_text(hjust = .5),
          legend.position = "bottom") + 
    xlab(NULL) +
    ylab(NULL)
}
