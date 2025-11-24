#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef enum
{
    COMUM = 1,
    ADITIVADA,
    ALCOOL
} combustivel_t;

typedef enum
{
    DINHEIRO = 1,
    LITRO
} pagamento_t;

double precoComum = 6.14;
double precoAditivada = 6.34;
double precoAlcool = 4.13;

void alterarPrecoCombustivel()
{
    combustivel_t combustivel;
    int invalido;
    int repetir;

    do 
    {
        repetir = 1;
        invalido =  0;
        printf("Deseja alterar o preço de algum dos combustíveis? (frentista):\n");
        printf("0 - Não\n");
        printf("1 - Gasolina Comum - Preço Atual R$%.2lf / Litro\n", precoComum);
        printf("2 - Gasolina Aditivada - Preço Atual R$%.2lf / Litro\n", precoAditivada);
        printf("3 - Álcool - Preço Atual R$%.2lf / Litro\n", precoAlcool);
        printf("Opção: ");
        scanf("%u", &combustivel);
        printf("\n");
        if (combustivel < 0 || combustivel > ALCOOL)
        {
            invalido = 1;
        }
        if (combustivel == 0)
        {
            repetir = 0;
        }
        
        switch (combustivel)
        {
        case 0:
            break;
        case COMUM:
            printf("Preço da gasolina comum: ");
            scanf("%lf", &precoComum);
            printf("\n");
            printf("Preço da gasolina comum atualizado para R$%.2lf\n\n", precoComum);
            break;
        case ADITIVADA:
            printf("Preço da gasolina aditivada: ");
            scanf("%lf", &precoAditivada);
            printf("\n");
            printf("Preço da gasolina aditivada atualizado para R$%.2lf\n\n", precoAditivada);
            break;
        case ALCOOL:
            printf("Preço do álcool: ");
            scanf("%lf", &precoAlcool);
            printf("\n");
            printf("Preço do álcool atualizao para R$%.2lf\n\n", precoAlcool);
            break;
        default:
            printf("Opção inválida. Tente novamente...\n\n");
            break;
        }
    } while (invalido || repetir);
}

combustivel_t getCombustivel()
{
    alterarPrecoCombustivel();

    combustivel_t combustivel;
    int invalido;
    do
    {
        invalido = 0;
        printf("Indique o combustível desejado:\n");
        printf("1 - Gasolina Comum R$%.2lf / Litro\n", precoComum);
        printf("2 - Gasolina Aditivada R$%.2lf / Litro\n", precoAditivada);
        printf("3 - Álcool R$%.2lf / Litro\n", precoAlcool);
        printf("Opção: ");
        scanf("%u", &combustivel);
        if (combustivel == 0 || combustivel > 3)
        {
            printf("Opção inválida. Tente novamente...\n");
            invalido = 1;
        }
    } while (invalido);
    printf("\n");
    return combustivel;
}

pagamento_t getFormaPagamento()
{
    combustivel_t pagamento;
    int invalido;
    do
    {
        invalido = 0;
        printf("Quantidade do combustível por:\n");
        printf("1 - Valor monetário\n");
        printf("2 - Litro\n");
        printf("Opção: ");
        scanf("%u", &pagamento);
        if (pagamento == 0 || pagamento > 2)
        {
            printf("Opção inválida. Tente novamente...\n");
            invalido = 1;
        }
    } while (invalido);
    printf("\n");
    return pagamento;
}

double getPrecoLitro(combustivel_t combustivel)
{
    switch (combustivel)
    {
    case COMUM:
        return 6.14;
        break;
    case ADITIVADA:
        return 6.34;
        break;
    case ALCOOL:
        return 4.13;
        break;
    default:
        return 0;
        break;
    }
}

double pagarCombustivel(pagamento_t pagamento, double precoLitro)
{
    if (pagamento == DINHEIRO)
    {
        double quantidade;
        printf("Insira quanto deseja pagar em combustível: ");
        scanf("%lf", &quantidade);
        int tempo = quantidade / precoLitro;
        sleep(tempo);
        return quantidade;
    }
    else
    {
        int litros;
        printf("Insira a quantidade de combustível desejado: ");
        scanf("%d", &litros);
        sleep(litros);
        return litros * precoLitro;
    }
    printf("\n");
}

unsigned int finalizaSistema()
{
    unsigned int continua;
    int invalido;
    do
    {
        invalido = 0;
        printf("Deseja finalizar o sistema?\n");
        printf("0 - Sim\n");
        printf("1 - Não\n");
        printf("Opção: ");
        scanf("%d", &continua);
        if (continua > 1)
        {
            printf("Opção inválida. Tente novamente...\n");
            invalido = 1;
        }
    } while (invalido);
    printf("\n");
    return continua;
}

void imprimirNotaFiscal(int it, combustivel_t combustivel, double quantidadePagar)
{
    FILE *arquivo;
    char carro[25];
    sprintf(carro, "NotaFiscal-Carro-%d.txt", it);

    char *tipoCombustivel;
    switch (combustivel)
    {
    case COMUM:
        tipoCombustivel = "Gasolina Comum";
        break;
    case ADITIVADA:
        tipoCombustivel = "Gasolina Aditivada";
        break;
    case ALCOOL:
        tipoCombustivel = "Álcool";
        break;
    default:
        tipoCombustivel = "";
        break;
    }

    arquivo = fopen(carro, "w");
    if (arquivo == NULL)
    {
        perror("Erro ao abrir arquivo");
        exit(1);
    }

    fprintf(arquivo, "CARRO %d\n", it);
    fprintf(arquivo, "Combustível: %s\n", tipoCombustivel);
    fprintf(arquivo, "Preço: R$%2.lf", quantidadePagar);

    fclose(arquivo);
}

void main(void)
{
    printf("=== INICIANDO SISTEMA DE BOMBA DE COMBUSTÍVEL ===\n\n");
    int it = 1;
    int continua = 1;
    while (continua)
    {

        combustivel_t combustivel = getCombustivel();
        pagamento_t pagamento = getFormaPagamento();

        double precoLitro = getPrecoLitro(combustivel);
        double quantidadePagar = pagarCombustivel(pagamento, precoLitro);

        imprimirNotaFiscal(it, combustivel, quantidadePagar);

        continua = finalizaSistema();
        it++;
    }
    printf("== FINALIZANDO SISTEMA DE BOMBA DE COMBUSTÍVEL ==\n");
}
